//
//  WSRequests.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

protocol WSRequestAlert {
    func requestAlert(title: String, message: String)
}

enum HttpRequestError : ErrorType {
    case NoSessionCookie
    case NoCSRFToken
    case JSONSerialisationFailure
}

class WSRequest {
    
    let LIMIT: Int = 1000
    
    var alertViewController : WSRequestAlert?
    
    let session = NSURLSession.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    let defaults = (UIApplication.sharedApplication().delegate as! AppDelegate).defaults
    
    
    // MARK: - Error checkers/handlers
    
//    // General error handler
//    func errorAlert(error: NSError) {
//        if alertViewController != nil {
//            self.alert("Error", message: error.localizedDescription)
//        }
//    }
//    
//    // Checks for http errors
//    func hasHTTPError(response: NSURLResponse) -> Bool {
//        
//        let httpResponse = response as! NSHTTPURLResponse
//        
//        if httpResponse.statusCode >= 400 {
//            return true
//        } else {
//            return false
//        }
//
//    }
    
    // Checks for CSRF failure message
    func hasFailedCSRF(data: NSData) -> Bool {
        
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
    
    //
    
//    // Handles http error codes
//    func httpErrorAlert(data: NSData?, response: NSURLResponse) {
//        
//        let httpResponse = response as! NSHTTPURLResponse
//        let statusCode = httpResponse.statusCode
//        let title = "HTTP " + String(statusCode)
//        var message: String = ""
//        
//        if data != nil {
//            do {
//                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
//                let response = json.objectAtIndex(0) as? String
//                if response != nil {
//                    message = response!
//                }
//            } catch {
//            }
//        }
//        
//        if alertViewController != nil {
//            self.alert(title, message: message)
//        }
//    }
    
//    // Displays general errors, returns false if there were no errors
//    func responseHasError(data: NSData?, response: NSURLResponse?, error: NSError?, silent: Bool = false) -> Bool {
//        
//        if error != nil {
//            
//            // An error occured
//            if !silent {
//                self.errorAlert(error!)
//            }
//            return true
//            
//        } else if response == nil {
//            
//            // No response
//            if !silent {
//                self.alert("Network Error", message: "No response")
//            }
//            return true
//            
//        }
//        
//        return false
//    }
    
//    // Gets the delegate view controller to show a pop up alert
//    func alert(title: String, message: String) {
//        dispatch_async(dispatch_get_main_queue(), {
//            self.alertViewController!.requestAlert(title, message: message)
//        })
//    }

    
    // MARK: - HTTP Request utilities
    
    // Creates a request
    //
    func buildRequest(service: WSRestfulService, params: [String: String]? = nil, token: String? = nil) -> NSMutableURLRequest? {
        
        let request = NSMutableURLRequest.withWSRestfulService(service)
        
        if (service.type != .login) && (service.method != .get) {
            
            // Add the session cookie to the header.
            if let sessionCookie = defaults.objectForKey(DEFAULTS_KEY_SESSION_COOKIE) as? String {
                request.addValue(sessionCookie, forHTTPHeaderField: "Cookie")
            } else {
                print("Failed to add session cookie to request header")
                return nil
            }
            
            // Add the CSRF token to the header.
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
    func dataRequest(request: NSMutableURLRequest, doWithResponse: (NSData?, NSURLResponse?, NSError?) -> Void) {
        print(request)
        let task = self.session.dataTaskWithRequest(request, completionHandler: doWithResponse)
        task.resume()
    }
    
    // Checks a request response and evaluates if retrying the request (after logging in again) is neccessary
    //
    func shouldRetryRequest(data: NSData?, response: NSURLResponse?, error: NSError?) -> Bool {
    
        // CSRF Failure
        if self.hasFailedCSRF(data!) {
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
    func tokenRequest(doWithToken: (token: String) -> Void) -> Void {
        
        if let tokenRequest = buildRequest(WSRestfulService(type: .token)!) {
            
            dataRequest(tokenRequest) { (tokenData, response, error) -> Void in
                
                if error != nil {
                    print("Error getting X-CSRF token")
                    return
                }
                
                if let token = String.init(data: tokenData!, encoding: NSUTF8StringEncoding) {
                    doWithToken(token: token)
                } else {
                    print("Could not decode token data")
                }
            }
        }
    }
    
    // Makes requests with a X-CSRF token in the header
    //
    func requestWithCSRFToken(service: WSRestfulService, params: [String: String]? = nil, retry: Bool = false, doWithResponse: (NSData?, NSURLResponse?, NSError?) -> Void) {
        
        // Request a X-CSRF token from the server
        tokenRequest { (token) -> Void in

            if let request = self.buildRequest(service, params: params, token: token) {

                self.dataRequest(request, doWithResponse: { (data, response, error) -> Void in
                    
                    // Retry the request if neccessary
                    if self.shouldRetryRequest(data, response: response, error: error) && (request.URL != WSURL.LOGOUT()) && retry {

                        // Login again to get a new session cookie
                        self.autoLogin({ () -> Void in
                            
                            // Retry the request.
                            self.requestWithCSRFToken(service, params: params, retry: false, doWithResponse: { (data, response, error) -> Void in
                                
                                    // Return final response for handling
                                    doWithResponse(data, response, error)
                            })
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
    func autoProcessLoginResponse(data: NSData?, response: NSURLResponse?, error: NSError?) -> Bool {
        
        if error != nil {
            print("Auto-login failed due to an error")
        }
        
        if data != nil {
            if let json = self.jsonDataToDictionary(data) {
                self.storeSessionData(json)
                return true
            }
        }
        
        return false
    }
    
    // Retrieves an image
    //
    func getImageWithURL(url: String, doWithImage: (image: UIImage?) -> Void ) {
        
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
    func login(username: String, password: String, doAfterLogin: (success: Bool) -> Void) {

        let params = ["username" : username, "password" : password]
        if let request = self.buildRequest(WSRestfulService(type: .login)!, params: params) {
            dataRequest(request, doWithResponse: { (data, response, error) -> Void in
                let success = self.autoProcessLoginResponse(data, response: response, error: error)
                doAfterLogin(success: success)
            })
        }
    }
    
    // To login automatically using a saved username and password
    //
    func autoLogin(doAfterLogin: () -> Void) {
        
        let username = defaults.stringForKey(DEFAULTS_KEY_USERNAME)
        let password = defaults.stringForKey(DEFAULTS_KEY_PASSWORD)
        
        if username != nil && password != nil {
            
            self.login(username!, password: password!) { (success: Bool) -> Void in
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
    func logout(doWithLogoutResponse: (success: Bool) -> Void) {
        
        let service = WSRestfulService(type: .logout)!

        requestWithCSRFToken(service, doWithResponse : { (data, response, error) -> Void in
            
            if let json = self.jsonDataToJSONObject(data!) {
                
                print("Logout request responded with: \(json)")
                doWithLogoutResponse(success: true)
                return
                
            } else {
                
                let httpResponse = response as! NSHTTPURLResponse
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
    func getHostDataForMapView(map: MKMapView, withHostData: (data: NSData?) -> Void) {
        
        let service = WSRestfulService(type: .searchByLocation)!
        var params = map.getWSMapRegion()
        params["limit"] = String(LIMIT)
        
        requestWithCSRFToken(service, params: params, retry: true, doWithResponse: { (data, response, error) -> Void in

            withHostData(data: data)
            
        })
    }
    
    // To search for hosts with a keyword
    //
    func getHostDataForKeyword(keyword: String, offset: Int = 0, withHostData: (data: NSData?) -> Void) {
        
        let service = WSRestfulService(type: .searchByKeyword)!
        var params = [String: String]()
        params["keyword"] = keyword
        params["offset"] = String(offset)
        params["limit"] = String(LIMIT)
        
        requestWithCSRFToken(service, params: params, retry: true, doWithResponse: { (data, response, error) -> Void in
            
            withHostData(data: data)
            
        })
    }
    
    // To get a users info with their uid
    //
    func getUserInfo(uid: Int, doWithUserInfo: (info: AnyObject?) -> Void) {
        
        let service = WSRestfulService(type: .userInfo, uid: uid)!
        
        if let request = buildRequest(service) {
            
            dataRequest(request) { (data, response, error) -> Void in
                
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
    }
    
    // To get the thumbnail size profile image of a user with their uid
    //
    func getUserThumbnailImage(uid: Int, doWithImage: (image: UIImage?) -> Void) {
        
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
    func getUserFeedback(uid: Int, doWithUserFeedback: (feedback: AnyObject?) -> Void) {
        
        let service = WSRestfulService(type: .userFeedback, uid: uid)!
        
        if let request = buildRequest(service) {
        
            dataRequest(request) { (data, response, error) -> Void in

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
    }
    
    // To create feedback on a user
    //
    
    
    // To send a new message
    //
    
    
    // To reply to a existing message
    //

    
    // To get a count of unread messages
    //
    func getUnreadMessagesCount(withCount: (count: Int?) -> Void) {
        
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
    func getAllMessageThreads(withMessageThreadData: (data: NSData?) -> Void) {
        
        let service = WSRestfulService(type: .getAllMessageThreads)!
        
        requestWithCSRFToken(service, retry: true, doWithResponse: { (data, response, error) -> Void in
            
                withMessageThreadData(data: data)
            
        })
    }
    
    // To get a single message thread
    //
    func getMessageThread(threadID: Int, withMessageThreadData: (data: NSData?) -> Void) {
        
        let service = WSRestfulService(type: .getMessageThread)!
        var params = [String: String]()
        params["thread_id"] = String(threadID)
        
        requestWithCSRFToken(service, params: params, retry: true, doWithResponse: { (data, response, error) -> Void in
            
            withMessageThreadData(data: data)
            
        })
    }

    
    // To mark a message thread as read or unread
    //
    
    
    
    // MARK: - Utilities
    
    // Stores a session name and cookie obtained from login
    //
    func storeSessionData(loginData: [String: AnyObject]?) {
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
    func jsonDataToJSONObject(data: NSData?) -> AnyObject? {
        
        if data != nil {
            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                return json
                
            } catch {
                print("Failed converting JSON data.")
            }
        }
        return nil
    }
    
    // Convert NSData to a dictionary
    //
    func jsonDataToDictionary(data: NSData?) -> [String: AnyObject]? {
        
        if let jsonDict = self.jsonDataToJSONObject(data) as? [String: AnyObject] {
            return jsonDict
        }
        return nil
        
    }
    
    // Checks if JSON data contains just an integer and returns it (or nil)
    //
    func intFromJSONData(data: NSData?) -> Int? {
        
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
