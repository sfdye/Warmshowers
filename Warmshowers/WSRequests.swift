//
//  WSRequests.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

//protocol WSRequestAlert {
//    func requestAlert(title: String, message: String)
//}

enum HttpRequestError : ErrorType {
    case NoSessionCookie
    case NoCSRFToken
    case JSONSerialisationFailure
}

struct WSRequest {
    
    static let MapSearchLimit: Int = 1000
    static let KeywordSearchLimit: Int = 50
    
    static let session = NSURLSession.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    static let defaults = (UIApplication.sharedApplication().delegate as! AppDelegate).defaults
    
    
    // MARK: - Error checkers/handlers
    
    // Checks for CSRF failure message
    static func hasFailedCSRF(data: NSData) -> Bool {
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            // Needed this line otherwise app would crash trying to index larger json
            if json.count == 1 {
                let responseBody = json.objectAtIndex(0) as? String
                if responseBody?.lowercaseString.rangeOfString("csrf validation failed") != nil {
                    return true
                }
            }
        } catch {
            print("Could not match CSRF failure message in response body.")
        }
        return false
        
    }

    
    // MARK: - HTTP Request utilities
    
//    // Cancels all tasks in the session
//    //
//    static func cancelAllTasks() {
//        
//        session.getAllTasksWithCompletionHandler { (sessionTasks) -> Void in
//            
//            for task in sessionTasks {
//                print("cancelling task \(task)")
//                task.cancel()
//            }
//        }
//    }
    
    // Creates a request
    //
    static func requestWithService(service: WSRestfulService, params: [String: String]? = nil, token: String? = nil) -> NSMutableURLRequest? {
        
        let request = NSMutableURLRequest.withWSRestfulService(service)
        
        // Add the session cookie to the header.
        if (service.type != .login && service.type != .token) {
            if let sessionCookie = defaults.objectForKey(DEFAULTS_KEY_SESSION_COOKIE) as? String {
                request.addValue(sessionCookie, forHTTPHeaderField: "Cookie")
            } else {
                print("Failed to add session cookie to request header")
                return nil
            }
        }
        
        // Add the CSRF token to the header.
        if (service.type != .login && service.method != .get) {
            if token != nil {
                request.addValue(token!, forHTTPHeaderField: "X-CSRF-Token")
            } else {
                print("Failed to add X-CSRF token to request header")
                return nil
            }
        }

        // Add the request parameters to the request body
        if params != nil {
            request.setBodyContent(params!)
        }
        
        return request
    }
    
    // Executes a general http request
    //
    static func dataRequest(request: NSMutableURLRequest, doWithResponse: (NSData?, NSURLResponse?, NSError?) -> Void) {
        print(request)
        let task = self.session.dataTaskWithRequest(request, completionHandler: doWithResponse)
        task.resume()
    }
    
    // Checks a request response and evaluates if retrying the request (after logging in again) is neccessary
    //
    static func shouldRetryRequest(data: NSData?, response: NSURLResponse?, error: NSError?) -> Bool {
        
        // No data or response recieved
        guard let data = data, let response = response else {
            return true
        }
        
        // CSRF Failure
        if self.hasFailedCSRF(data) {
            return true
        }
        
        // http failure codes
        let httpResponse = response as! NSHTTPURLResponse
        
        // 403: Forbidden -> need to re-login and try again
        if httpResponse.statusCode == 403 {
            return true
        }
        
        return false
    }
    
    // Requests a X-CSRF Token from the server
    //
    static func tokenRequest(doWithToken: (token: String?, response: NSURLResponse?, error: NSError?) -> Void) -> Void {
        
        let service = WSRestfulService(type: .token)!
        
        request(service) { (data, response, error) -> Void in
            
            guard let data = data, let _ = response where error == nil else {
                print("Error getting X-CSRF token")
                doWithToken(token: nil, response: response, error: error)
                return
            }
            
            if let token = String.init(data: data, encoding: NSUTF8StringEncoding) {
                doWithToken(token: token, response: response, error: nil)
            } else {
                print("Could not decode token data")
                doWithToken(token: nil, response: response, error: error)
            }
        }
    }
    
    // Makes a normal get request
    //
    static func request(service: WSRestfulService, params: [String: String]? = nil, doWithResponse: (NSData?, NSURLResponse?, NSError?) -> Void) {
        
        if let request = requestWithService(service) {
            dataRequest(request, doWithResponse: doWithResponse)
        } else {
            print("Failed to build http request")
        }
        
    }
    
    // Makes requests with a X-CSRF token in the header
    //
    static func requestWithCSRFToken(service: WSRestfulService, params: [String: String]? = nil, retry: Bool = false, doWithResponse: (NSData?, NSURLResponse?, NSError?) -> Void) {
        
        // Request a X-CSRF token from the server
        tokenRequest { (token, response, error) -> Void in
            
            guard let token = token where error == nil else {
                doWithResponse(nil, response, error)
                return
            }

            if let request = self.requestWithService(service, params: params, token: token) {

                self.dataRequest(request, doWithResponse: { (data, response, error) -> Void in
                    
                    // Retry the request if neccessary
                    if self.shouldRetryRequest(data, response: response, error: error) && (request.URL != WSURL.LOGOUT()) && retry {

                        // Login again to get a new session cookie
                        self.autoLogin({ () -> Void in
                            
                            // Retry the request.
                            self.requestWithCSRFToken(service, params: params, retry: false, doWithResponse: doWithResponse)
                        })
                        
                    } else {
                        
                        // Return the successful first response or error for handling
                        doWithResponse(data, response, error)
                    }
                    
                })
            }
        }
    }
    
    
    // Processes the response from a login request and returns true for a successful login
    //
    static func autoProcessLoginResponse(data: NSData?, response: NSURLResponse?, error: NSError?) -> Bool {
        
        guard error == nil else {
            print("Login failed due to an error")
            return false
        }
        
        guard let data = data, let response = response else {
            print("Nil data or response to login request")
            return false
        }
        
        let httpResponse = response as! NSHTTPURLResponse
        if httpResponse.statusCode == 401 {
            print("Unauthorized login")
        }
        
        if let json = self.jsonDataToDictionary(data) {
            self.storeSessionData(json)
            return true
        }
        return false
    }
    
    // Retrieves an image
    //
    static func getImageWithURL(url: String, doWithImage: (image: UIImage?) -> Void ) {
        
        if let url = NSURL(string: url) {
            
            let request = NSMutableURLRequest.init()
            request.URL = url
            request.HTTPMethod = "GET"
            
            dataRequest(request, doWithResponse: { (data, response, error) -> Void in
                if data != nil {
                    let image = UIImage(data: data!)
                    doWithImage(image: image)
                } else {
                    print("Image request failed for url \(request.URL)")
                }
            })
        }
    }
    
    
    // MARK: - Warmshowers RESTful API requests
    
    // Login request that takes a new username and password
    //
    static func login(username: String, password: String, doAfterLogin: (success: Bool, response: NSURLResponse?, error: NSError?) -> Void) {
        
        let service = WSRestfulService(type: .login)!
        let params = ["username" : username, "password" : password]
        
        requestWithCSRFToken(service, params: params) { (data, response, error) -> Void in
            if self.autoProcessLoginResponse(data, response: response, error: error) {
                doAfterLogin(success: true, response: nil, error: nil)
            } else {
                doAfterLogin(success: false, response: response, error: error)
            }
        }
    }
    
    // To login automatically using a saved username and password
    //
    static func autoLogin(doAfterLogin: () -> Void) {
        
        let username = defaults.stringForKey(DEFAULTS_KEY_USERNAME)
        let password = defaults.stringForKey(DEFAULTS_KEY_PASSWORD)
        
        if username != nil && password != nil {
            
            self.login(username!, password: password!) { (success, response, error) -> Void in
                if success {
                    print("Autologin succeeded")
                    doAfterLogin()
                }
            }
            
        } else {
            print("Autologin failed. Username or password not stored yet.")
        }
    }
    
    // Logout of warmshowers
    //
    static func logout(doWithLogoutResponse: (success: Bool) -> Void) {
        
        let service = WSRestfulService(type: .logout)!

        requestWithCSRFToken(service, doWithResponse : { (data, response, error) -> Void in
            
            guard let data = data, let httpResponse = response as? NSHTTPURLResponse where error == nil else {
                doWithLogoutResponse(success: false)
                return
            }
            
            if let _ = self.jsonDataToJSONObject(data) {
                doWithLogoutResponse(success: true)
                return
            } else {
                print("Logout request responded with: \(httpResponse)")
                if httpResponse.statusCode == 406 {
                    // http 406: unauthorized. The user was already logged out
                    doWithLogoutResponse(success: true)
                    return
                }
            }
            
            doWithLogoutResponse(success: false)
        })
    }

    // To search for hosts with a map region
    //
    static func getHostDataForMapView(map: MKMapView, withHostData: (data: NSData?) -> Void) {
        
        let service = WSRestfulService(type: .searchByLocation)!
        
        var params = map.getWSMapRegion()
        params["limit"] = String(MapSearchLimit)
        
        requestWithCSRFToken(service, params: params, retry: true, doWithResponse: { (data, response, error) -> Void in
            withHostData(data: data)
        })
        
        // EXAMPLE JSON FOR USER LOCATION OBJECTS
//            {
//                access = 1424441219;
//                city = Caracas;
//                country = ve;
//                created = 1360693669;
//                distance = "1589.2337810280335";
//                fullname = "Ximena Carrasco";
//                latitude = "10.491016";
//                login = 1424441033;
//                longitude = "-66.902061";
//                name = "Mena Carrasco";
//                notcurrentlyavailable = 0;
//                picture = 142728;
//                position = "10.491016,-66.902061";
//                "postal_code" = 1011;
//                "profile_image_map_infoWindow" = "https://www.warmshowers.org/files/styles/map_infoWindow/public/pictures/picture-42795.jpg?itok=YdnATdzn";
//                "profile_image_mobile_photo_456" = "https://www.warmshowers.org/files/styles/mobile_photo_456/public/pictures/picture-42795.jpg?itok=ti5zeS1Y";
//                "profile_image_mobile_profile_photo_std" = "https://www.warmshowers.org/files/styles/mobile_profile_photo_std/public/pictures/picture-42795.jpg?itok=dQL6cIAv";
//                "profile_image_profile_picture" = "https://www.warmshowers.org/files/styles/profile_picture/public/pictures/picture-42795.jpg?itok=xdkN20GR";
//                province = a;
//                source = 5;
//                street = "";
//                uid = 42795;
//        }
        
    }
    
    // To search for hosts with a keyword
    //
    static func getHostDataForKeyword(keyword: String, offset: Int = 0, withHostData: (data: NSData?) -> Void) {
        
        let service = WSRestfulService(type: .searchByKeyword)!
        var params = [String: String]()
        params["keyword"] = keyword
        params["offset"] = String(offset)
        params["limit"] = String(KeywordSearchLimit)
        
        requestWithCSRFToken(service, params: params, retry: true, doWithResponse: { (data, response, error) -> Void in
            withHostData(data: data)
        })
        
        // EXAMPLE JSON FOR USER OBJECT
        //        {
        //            URL = "";
        //            access = 1421382979;
        //            additional = "Sinhagad Road";
        //            becomeavailable = 1419577200;
        //            bed = 1;
        //            bikeshop = 200m;
        //            campground = "no campgrounds in India";
        //            city = Pune;
        //            "comment_notify_settings" =     {
        //                "comment_notify" = 1;
        //                "node_notify" = 1;
        //                uid = 122;
        //            };
        //            comments = "I and my wife, Shiwanee will be happy to host you. starting from finding your way into town, we can help you with planning hiking/biking excursions in the nearby hills, plan any other tours in our state, book tickets, help with logistics etc.
        //            \nWe are both employed in the computer software industry. Hosting is not our business. We do it only because we think it is our duty towards fellow tourers.";
        //            country = in;
        //            created = 1020060000;
        //            "email_opt_out" = 0;
        //            "fax_number" = "";
        //            food = 1;
        //            fullname = "Sujay N. Patankar";
        //            "hide_donation_status" = "<null>";
        //            homephone = "+91-20-24308058";
        //            howdidyouhear = "Touring list on phred.org";
        //            kitchenuse = 1;
        //            language = "en-working";
        //            languagesspoken = "English, Marathi, Hindi";
        //            "last_unavailability_pester" = 0;
        //            latitude = "18.492674";
        //            laundry = 1;
        //            lawnspace = 0;
        //            login = 1421382979;
        //            longitude = "73.833532";
        //            maxcyclists = 2;
        //            mobilephone = "+91-9881071197";
        //            motel = "2 Km";
        //            name = "thepunekar@yahoo.com";
        //            notcurrentlyavailable = 0;
        //            picture =     {
        //                fid = 130548;
        //                filemime = "image/jpeg";
        //                filename = "picture-122.jpg";
        //                filesize = 17956;
        //                status = 1;
        //                timestamp = 1444780947;
        //                uid = 122;
        //                uri = "public://pictures/picture-122.jpg";
        //            };
        //            "postal_code" = 411030;
        //            "preferred_notice" = asap;
        //            "profile_image_map_infoWindow" = "https://www.warmshowers.org/files/styles/map_infoWindow/public/pictures/picture-122.jpg?itok=5jf5hr3T";
        //            "profile_image_mobile_photo_456" = "https://www.warmshowers.org/files/styles/mobile_photo_456/public/pictures/picture-122.jpg?itok=d_J4Kkg8";
        //            "profile_image_mobile_profile_photo_std" = "https://www.warmshowers.org/files/styles/mobile_profile_photo_std/public/pictures/picture-122.jpg?itok=oB3VzV-W";
        //            "profile_image_profile_picture" = "https://www.warmshowers.org/files/styles/profile_picture/public/pictures/picture-122.jpg?itok=h4VyrE9N";
        //            province = mm;
        //            sag = 1;
        //            "set_available_timestamp" = 0;
        //            "set_unavailable_timestamp" = 0;
        //            shower = 1;
        //            signature = "";
        //            "signature_format" = 1;
        //            source = 1;
        //            status = 1;
        //            storage = 1;
        //            street = "15, Vastushree, Behind IBP Petrol Pump,";
        //            theme = "";
        //            timezone = "Asia/Kolkata";
        //            uid = 122;
        //            workphone = "+91-20-42003150";
        //        }
    }
    
    // To get a users info with their uid
    //
    static func getUserInfo(uid: Int, doWithUserInfo: (info: AnyObject?) -> Void) {
        
        let service = WSRestfulService(type: .userInfo, uid: uid)!
        
        request(service) { (data, response, error) -> Void in
            
            if error != nil {
                print("Error getting user info")
                return
            }
            
            if data != nil {
                let userObject = self.jsonDataToJSONObject(data)
                doWithUserInfo(info: userObject)
            }
        }
    }
    
    // To get the thumbnail size profile image of a user with their uid
    //
    static func getUserThumbnailImage(uid: Int, doWithImage: (image: UIImage?) -> Void) {
        
        getUserInfo(uid) { (info) -> Void in
            if info != nil {
                if let url = info?.valueForKey("profile_image_map_infoWindow") as? String {
                    self.getImageWithURL(url, doWithImage: { (image) -> Void in
                        doWithImage(image: image)
                    })
                }
            } else {
                print("Failed to get user object for thumbnail image request")
            }
        }
    }
    
    // To get feedback on a user
    //
    static func getUserFeedback(uid: Int, doWithUserFeedback: (feedback: AnyObject?) -> Void) {
        
        let service = WSRestfulService(type: .userFeedback, uid: uid)!
        
        request(service) { (data, response, error) -> Void in
            if error != nil {
                print("Error getting user feedback")
                return
            }
            
            if data != nil {
                let userFeedback = self.jsonDataToJSONObject(data)
                doWithUserFeedback(feedback: userFeedback)
            }
        }
    }
    
    // To create feedback on a user
    //
    static func createUserFeedback(feedback: WSRecommendation, userName: String, completion: (success: Bool) -> Void ) {
        
        let service = WSRestfulService(type: .createFeedback)!
        
        var params = [String: String]()
        params["node[type]"] = "trust_referral"
        params["node[field_member_i_trust][0][uid][uid]"] = userName
        params["node[field_rating][value]"] = feedback.rating.rawValue
        params["node[body]"] = feedback.body
        params["node[field_guest_or_host][value]"] = feedback.recommendationFor.rawValue
        params["node[field_hosting_date][0][value][year]"] = String(feedback.year)
        params["node[field_hosting_date][0][value][month]"] = String(feedback.month)
        
        requestWithCSRFToken(service, params: params, retry: true, doWithResponse: { (data, response, error) -> Void in
            
            guard let httpResponse = response as? NSHTTPURLResponse where data != nil && error == nil else {
                completion(success: false)
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(success: false)
                return
            }
            
            completion(success: true)
        })
    }
    
    // To send a new message
    //
    static func sendNewMessage(message: CDWSMessage, completion: (success: Bool) -> Void) {
        
        func makeRecipientString(message: CDWSMessage) -> String? {
            
            guard let recipients = message.recipients where recipients.count > 0 else {
                return nil
            }
            
            var recipientString = ""
            for user in recipients {
                if recipientString == "" {
                    recipientString += user.name
                } else {
                    recipientString += "," + user.name
                }
            }
            return recipientString
        }
        
        guard let recipients = makeRecipientString(message),
              let subject = message.thread?.subject,
              let body = message.body
            else {
                return
        }
        
        let service = WSRestfulService(type: .newMessage)!
        
        var params = [String: String]()
        params["recipients"] = recipients
        params["subject"] = subject
        params["body"] = body
        
        requestWithCSRFToken(service, params: params, retry: true, doWithResponse: { (data, response, error) -> Void in
            
            guard let httpResponse = response as? NSHTTPURLResponse where data != nil && error == nil else {
                completion(success: false)
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(success: false)
                return
            }
            
            completion(success: true)
        })
    }

    // To reply to a existing message
    //
    static func replyToMessage(threadID: Int, body: String, completion: (success: Bool) -> Void) {
        
        let service = WSRestfulService(type: .replyToMessage)!
        
        var params = [String: String]()
        params["thread_id"] = String(threadID)
        params["body"] = body
        
        requestWithCSRFToken(service, params: params, retry: true, doWithResponse: { (data, response, error) -> Void in
            
            guard let httpResponse = response as? NSHTTPURLResponse where data != nil && error == nil else {
                completion(success: false)
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(success: false)
                return
            }
            
            completion(success: true)
        })
    }

    // To get a count of unread messages
    //
    static func getUnreadMessagesCount(withCount: (count: Int?) -> Void) {
        
        let service = WSRestfulService(type: .unreadMessageCount)!
        
        requestWithCSRFToken(service, retry: true, doWithResponse: { (data, response, error) -> Void in
            
            if data != nil {
                let count = self.intFromJSONData(data)
                withCount(count: count)
            }
        })
    }

    // To get all message threads
    //
    static func getAllMessageThreads(withMessageThreadData: (data: NSData?) -> Void) {
        
        let service = WSRestfulService(type: .getAllMessageThreads)!
        
        requestWithCSRFToken(service, retry: true, doWithResponse: { (data, response, error) -> Void in
            
                withMessageThreadData(data: data)
            
        })
    }
    
    // To get a single message thread
    //
    static func getMessageThread(threadID: Int, withMessageThreadData: (data: NSData?) -> Void) {
        
        let service = WSRestfulService(type: .getMessageThread)!
        var params = [String: String]()
        params["thread_id"] = String(threadID)
        
        requestWithCSRFToken(service, params: params, retry: true, doWithResponse: { (data, response, error) -> Void in
            withMessageThreadData(data: data)
        })
    }
    
    // To mark a message thread as read or unread
    //
    static func markMessageThread(threadID: Int, read: Bool = true, withResponse: (data: NSData) -> Void) {
        
        let service = WSRestfulService(type: .markMessage)!
        var params = [String: String]()
        params["thread_id"] = String(threadID)
        // status: 0 = read, 1 = unread
        params["status"] = String((!read).hashValue)
        
        requestWithCSRFToken(service, params: params, retry: true, doWithResponse: { (data, response, error) -> Void in
            
            guard let data = data else {
                return
            }
            withResponse(data: data)
        })
    }
    
    
    // MARK: - Utilities
    
    // Stores a session name and cookie obtained from login
    //
    static func storeSessionData(loginData: [String: AnyObject]?) {
        if loginData != nil {
            
            // Store the session cookie
            let sessionName = loginData!["session_name"] as? String
            let sessid = loginData!["sessid"] as? String
            if (sessionName != nil) && (sessid != nil) {
                let sessionCookie = sessionName! + "=" + sessid!
                defaults.setValue(sessionCookie, forKey: DEFAULTS_KEY_SESSION_COOKIE)
            }
            
            // Store the users uid
            if let user = loginData!["user"] {
                if let uid = user["uid"] {
                    defaults.setValue(uid, forKey: DEFAULTS_KEY_UID)
                }
            }
            
            // Save the session data
            defaults.synchronize()
        }
    }
    
    // Convert NSData to a json dictionary
    //
    static func jsonDataToJSONObject(data: NSData?) -> AnyObject? {
        
        guard let data = data else {
            return nil
        }
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            return json
        } catch {
            print("Failed converting JSON data.")
        }
        return nil
    }
    
    // Convert NSData to a dictionary
    //
    static func jsonDataToDictionary(data: NSData?) -> [String: AnyObject]? {
        
        if let jsonDict = self.jsonDataToJSONObject(data) as? [String: AnyObject] {
            return jsonDict
        }
        return nil
    }
    
    // Checks if JSON data contains just an integer and returns it (or nil)
    //
    static func intFromJSONData(data: NSData?) -> Int? {
        
        if let json = jsonDataToJSONObject(data) {
            if json.count == 1 {
                let count: Int? = json.objectAtIndex(0).integerValue
                return count
            }
        }
        return nil
    }
    
}
    
// To create NSMutableRequests with a dictionary of post parameters
//
extension NSMutableURLRequest {
    
    // To convert a dictionary of post parameters into a parameter string and sets the string as the http body
    //
    func setBodyContent(params: [String: String]) {
        
        var requestBodyAsString = ""
        var firstOneAdded = false
        let paramKeys:Array<String> = Array(params.keys)
        
        for paramKey in paramKeys {
            if(!firstOneAdded) {
                requestBodyAsString += paramKey + "=" + params[paramKey]!
                firstOneAdded = true
            }
            else {
                requestBodyAsString += "&" + paramKey + "=" + params[paramKey]!
            }
        }
        
        self.HTTPBody = requestBodyAsString.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    // Initialises a NSMutableURLRequest for a particular Warmshowers Restful service
    //
    class func withWSRestfulService(service: WSRestfulService) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest.init()
        request.URL = service.url
        request.HTTPMethod = service.methodAsString
        
        if service.type == .token {
            request.addValue("text/plain", forHTTPHeaderField: "Accept")
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        return request
    }
    
}


// To get the map bounds when searching for hosts
//
extension MKMapView {
    
    // Returns the current coordinate limits of a mapview
    // Used for getting hosts in the current displayed region in getHostDataForMapView
    //
    func getWSMapRegion(limit: Int = 100) -> [String: String] {
        
        let region = self.region
        
        let regionLimits: [String: String] = [
            "minlat": String(region.center.latitude - region.span.latitudeDelta / Double(2)),
            "maxlat": String(region.center.latitude + region.span.latitudeDelta / Double(2)),
            "minlon": String(region.center.longitude - region.span.longitudeDelta / Double(2)),
            "maxlon": String(region.center.longitude + region.span.longitudeDelta / Double(2)),
            "centerlat": String(region.center.latitude),
            "centerlon": String(region.center.longitude)
        ]
        
        return regionLimits
    }
    
}
