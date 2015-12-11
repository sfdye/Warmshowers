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

class WSRequest {
    
    let LIMIT: Int = 1000
    
    var alertViewController : WSRequestAlert?
    
    let session = NSURLSession.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    let defaults = (UIApplication.sharedApplication().delegate as! AppDelegate).defaults
    
    
    // MARK: - Error handlers
    
    // General error handler
    func errorAlert(error: NSError) {
        if alertViewController != nil {
            self.alert("Error", message: error.localizedDescription)
        }
    }
    
    // Checks for http errors
    func hasHTTPError(response: NSURLResponse) -> Bool {
        
        let httpResponse = response as! NSHTTPURLResponse
        
        if httpResponse.statusCode >= 400 {
            return true
        } else {
            return false
        }

    }
    
    // Checks for CSRF failure message
    func hasFailedCSRF(data: NSData) -> Bool {
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            // Needed this line otherwise app would crash trying to index larger json
            if json.count == 1 {
                let responseBody = json.objectAtIndex(0) as? String
                if responseBody?.lowercaseString.rangeOfString("csrf validation failed") != nil {
                    print("Failed CSRF.")
                    return true
                }
            }
        } catch {
            print("Could not match CSRF failure message in response body.")
        }
        return false
        
    }
    
    // Handles http error codes
    func httpErrorAlert(data: NSData?, response: NSURLResponse) {
        
        let httpResponse = response as! NSHTTPURLResponse
        let statusCode = httpResponse.statusCode
        let title = "HTTP " + String(statusCode)
        var message: String = ""
        
        if data != nil {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                let response = json.objectAtIndex(0) as? String
                if response != nil {
                    message = response!
                }
            } catch {
            }
        }
        
        if alertViewController != nil {
            self.alert(title, message: message)
        }
    }
    
    // Displays general errors, returns false if there were no errors
    func responseHasError(data: NSData?, response: NSURLResponse?, error: NSError?, silent: Bool = false) -> Bool {
        
        if error != nil {
            
            // An error occured
            if !silent {
                self.errorAlert(error!)
            }
            return true
            
        } else if response == nil {
            
            // No response
            if !silent {
                self.alert("Network Error", message: "No response")
            }
            return true
            
        }
        
        return false
    }
    
    // Gets the delegate view controller to show a pop up alert
    func alert(title: String, message: String) {
        dispatch_async(dispatch_get_main_queue(), {
            self.alertViewController!.requestAlert(title, message: message)
        })
    }

    
    // MARK: - HTTP Request utilities
    
    // Create a request
    func makeRequest(url: NSURL, type: String, params: [String: String]? = nil, token: String? = nil) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest.init()
        request.URL = url
        request.HTTPMethod = type
        
        if request.URL == WSURL.TOKEN() {
            request.addValue("text/plain", forHTTPHeaderField: "Accept")
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        if (request.URL != WSURL.LOGIN()) && (request.URL != WSURL.TOKEN()) {
            
            let sessionCookie = defaults.objectForKey(SESSION_COOKIE) as? String
            
            if sessionCookie != nil {
                request.addValue(sessionCookie!, forHTTPHeaderField: "Cookie")
            } else {
                print("Could not add session cookie to the request.")
            }

            if token != nil {
                request.addValue(token!, forHTTPHeaderField: "X-CSRF-Token")
            } else {
                print("Could not add a X-CSRF token to the request.")
            }
            
        }
        
        if params != nil {
            request.setBodyContent(params!)
        }
        
        return request
        
    }
    
    // General request function
    func dataRequest(request: NSMutableURLRequest, doWithResponse: (NSData?, NSURLResponse?, NSError?) -> Void) {
        
        let task = self.session.dataTaskWithRequest(request, completionHandler: doWithResponse)
        
        task.resume()
        
    }
    
    // For making requests that require a X_CSRF token in the header
    func requestWithCSRFToken(url: NSURL, type: String, params: [String: String]? = nil, retry: Bool = false, doWithResponse: (NSData?, NSURLResponse?, NSError?) -> Void) {
        
        // get a X-CSRF Token from warmshowers.org
        let tokenRequest = makeRequest(WSURL.TOKEN(), type: "GET")
        dataRequest(tokenRequest) { (tokenData, response, error) -> Void in
            
            // Check the response for errors
            if !self.responseHasError(tokenData, response: response, error: error, silent: retry) {
                
                // Decode the token and make the actual request
                if let token = String.init(data: tokenData!, encoding: NSUTF8StringEncoding) {
                    
                    let request = self.makeRequest(url, type: type, params: params, token: token)
                    
                    if !retry {
                        print("Making final request to \(request.URL!) with token \(token)")
                    } else {
                        print("Making a request to \(request.URL!) with token \(token)")
                    }
                    
                    self.dataRequest(request, doWithResponse: { (data, response, error) -> Void in
                        
                        // Check the response for errors
                        if !self.responseHasError(data, response: response, error: error, silent: retry) {
                            
                            // Check for CSRF failure and retry if needed
                            if self.hasFailedCSRF(data!) && retry {
                                
                                // Login again and retry (if it is not a logout request)
                                print("Logging in again to retry the request")
                                if request.URL != WSURL.LOGOUT() {
                                    
                                    self.autologin({ () -> Void in
                                        
                                        print("Retrying the request")
                                        self.requestWithCSRFToken(url, type: type, params: params, retry: false, doWithResponse: { (data, response, error) -> Void in
                                            
                                            // Check the response for errors
                                            if !self.responseHasError(tokenData, response: response, error: error) {
                                                
                                                // Sucessful retry
                                                doWithResponse(data, response, error)
                                                
                                            }
                                            
                                            
                                        })
                                    })
                                    
                                } else {
                                    // Continue with the logout
                                    doWithResponse(data, response, error)
                                }
                                
                            } else {
                                // Successful first attempt or unsuccessful final attempt
                                doWithResponse(data, response, error)
                                
                            }
                            
                        }
                    })

                } else {
                    print("Could not decode token data")
                }
                
            }
        }
    }
    
    
    // MARK: - Warmshowers RESTful API requests
    
    func login(username: String, password: String, doAfterLogin: (success: Bool) -> Void) {

        let params = ["username" : username, "password" : password]
        let request = self.makeRequest(WSURL.LOGIN(), type: "POST", params: params)
        dataRequest(request, doWithResponse: { (data, response, error) -> Void in
            
            print("Received login response")
            
            if self.hasHTTPError(response!) {
                
                // Got a response, but with a HTTP error
                self.httpErrorAlert(data, response: response!)
                
            } else if data != nil {

                if let json = self.jsonDataToDictionary(data) {
                    
                    self.storeSessionCookie(json)
                    doAfterLogin(success: true)
                    
                }
                
            }
            
        })
    }

    func autologin(doAfterLogin: () -> Void) {
        
        let username = defaults.stringForKey(USERNAME)
        let password = defaults.stringForKey(PASSWORD)
        
        if username != nil && password != nil {
            
            self.login(username!, password: password!) { (success) -> Void in
                if success {
                    doAfterLogin()
                }
                // Else: Do nothing. Errors have been handled by self.dataRequest
            }
            
        } else {
            // Do nothing. Errors will been handled by self.dataRequest on the second attempt
            print("Autologin failed. Username or password not stored yet.")
        }
    }
    
    func storeSessionCookie(loginData: [String: AnyObject]?) {
        if loginData != nil {
            let sessionName = loginData!["session_name"] as? String
            let sessid = loginData!["sessid"] as? String
            if (sessionName != nil) && (sessid != nil) {
                let sessionCookie = sessionName! + "=" + sessid!
                defaults.setValue(sessionCookie, forKey: SESSION_COOKIE)
                defaults.synchronize()
            }
        }
    }
    
    func logout(doWithLogoutResponse: (success: Bool) -> Void) {

        requestWithCSRFToken(WSURL.LOGOUT(), type: "POST", doWithResponse : { (data, response, error) -> Void in
            
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

    // To update a map with annotations marking warmshowers member locations
    func getHostDataForMapView(map: MKMapView, withHostData: (data: NSData?) -> Void) {
        
        let params = map.getWSMapRegion(LIMIT)
        
        requestWithCSRFToken(WSURL.LOCATION_SEARCH() , type: "POST", params: params, retry: true, doWithResponse: { (data, response, error) -> Void in

            withHostData(data: data)
            
        })
    }
    
    // To get a count of unread messages
    func getUnreadMessagesCount(withCount: (count: Int?) -> Void) {
        
        requestWithCSRFToken(WSURL.UNREAD_MESSAGE_COUNT() , type: "POST", retry: true, doWithResponse: { (data, response, error) -> Void in
            
            if data != nil {
                let count = self.intFromJSONData(data)
                withCount(count: count)
            }
        })
    }

    // To get all message threads
    func getMessageThreads(withMessageThreadData: (data: NSData?) -> Void) {
        
        requestWithCSRFToken(WSURL.GET_ALL_MESSAGES() , type: "POST", retry: true, doWithResponse: { (data, response, error) -> Void in
            
                withMessageThreadData(data: data)
            
        })
    }
    
    // MARK: - Utilities
    
    // Convert NSData to a json dictionary
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
    
    func jsonDataToDictionary(data: NSData?) -> [String: AnyObject]? {
        
        if let jsonDict = self.jsonDataToJSONObject(data) as? [String: AnyObject] {
            return jsonDict
        }
        return nil
        
    }
    
    
    
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
extension NSMutableURLRequest {
    
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
    
}

extension MKMapView {
    
    func getWSMapRegion(limit: Int = 100) -> [String: String] {
        
        let region = self.region
        
        let regionLimits: [String: String] = [
            "minlat": String(region.center.latitude - region.span.latitudeDelta / Double(2)),
            "maxlat": String(region.center.latitude + region.span.latitudeDelta / Double(2)),
            "minlon": String(region.center.longitude - region.span.longitudeDelta / Double(2)),
            "maxlon": String(region.center.longitude + region.span.longitudeDelta / Double(2)),
            "centerlat": String(region.center.latitude),
            "centerlon": String(region.center.longitude),
            "limit": String(limit)
        ]
        
        return regionLimits
        
    }
    
}
