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
    
    
    // MARK: - Error handlers
    
    // General error handler
    func errorAlert(error: NSError) {
        if alertViewController != nil {
            self.alert("Error", message: error.localizedDescription)
        }
    }
    
    // Check for http errors
    func hasHTTPError(response: NSURLResponse) -> Bool {
        
        let httpResponse = response as! NSHTTPURLResponse
        
        if httpResponse.statusCode >= 400 {
            return true
        } else {
            return false
        }

    }
    
    func hasFailedCSRF(data: NSData) -> Bool {
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            let responseBody = json.objectAtIndex(0) as? String
            if responseBody?.lowercaseString.rangeOfString("csrf validation failed") != nil {
                print("Failed CSRF.")
                return true
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
    
    // General error and url response handler
    func errorHandler(data: NSData?, response: NSURLResponse?, error: NSError?) {
        
        if error != nil {
            // show an error alert
            self.errorAlert(error!)
            return
        }
        
        if response != nil {
            // http error alert
            let httpResponse = response as! NSHTTPURLResponse
            if httpResponse.statusCode > 200 {
                self.httpErrorAlert(data, response: httpResponse)
                return
            }
        }
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
    func requestWithCSRFToken(url: NSURL, type: String, params: [String: String]? = nil, doWithResponse: (NSData?, NSURLResponse?, NSError?) -> Void) {
        
        // get a X-CSRF Token from warmshowers.org
        let tokenRequest = makeRequest(WSURL.TOKEN(), type: "GET")
        
        dataRequest(tokenRequest) { (tokenData, response, error) -> Void in
            
            if let token = String.init(data: tokenData!, encoding: NSUTF8StringEncoding) {

                // make the actual request
                let request = self.makeRequest(url, type: type, params: params, token: token)
                
                print("Making a request to \(request.URL!) with token \(token)")
                self.dataRequest(request, doWithResponse: { (data, response, error) -> Void in
                    
                    // check for CSRF failure and retry if needed
                    if response != nil {
                        if self.hasHTTPError(response!) {
                            
                            print("HTTP error response recieved.")
                            if self.hasFailedCSRF(data!) {
                                
                                // login again and retry
                                print("Logging in again to retry the request")
                                self.autologin({ () -> Void in
                                    print("Retrying the request")
                                    self.dataRequest(request, doWithResponse: doWithResponse)
                                })
                                
                            } else {
                                self.httpErrorAlert(data!, response: response!)
                            }
                        }
                    }

                    // else if there was no CSRF failure return for error handling
                    doWithResponse(data, response, error)
                    
                })
                
            } else {
                self.errorHandler(tokenData, response: response, error: error)
            }
        }
    }
    
    
    // MARK: - Warmshowers RESTful API requests
    
    func login(username: String, password: String, doAfterLogin: (success: Bool) -> Void) {

        let params = ["username" : username, "password" : password]
        let request = self.makeRequest(WSURL.LOGIN(), type: "POST", params: params)
        dataRequest(request, doWithResponse: { (data, response, error) -> Void in
            
            if data == nil {
                self.errorHandler(data!, response: response, error: error)
            } else {
                
                print("Recieved login data")
                // check for CSRF failure and retry if needed
                if response != nil {
                    if self.hasHTTPError(response!) {
                        
                        print("HTTP error response recieved.")
                        let statusCode = (response as! NSHTTPURLResponse).statusCode
                        if statusCode == 406 {
                            
                            // the user was already logged in
                            do {
                                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                                let responseBody = json.objectAtIndex(0) as? String
                                print(responseBody)
                            } catch {
                                
                            }
                        } else {
                            self.httpErrorAlert(data!, response: response!)
                        }
                    }
                }
                
                self.errorHandler(data!, response: response, error: error)
                if let json = self.jsonDataToDictionary(data) {
                    self.storeSessionCookie(json)
                    doAfterLogin(success: true)
                    return
                }
            }
            
            doAfterLogin(success: false)

        })
    }
    
    func autologin(doAfterLogin: () -> Void) {
        
        let username = defaults.valueForKey(USERNAME)?.stringValue
        let password = defaults.valueForKey(PASSWORD)?.stringValue
        print(password)
        if username != nil && password != nil {
            
            self.login(username!, password: password!) { (success) -> Void in
                if success {
                    doAfterLogin()
                } else {
                    self.alert("Error", message: "Could not complete the login process successfully.")
                }
            }
            
        } else {
            print("Username or password not stored yet.")
            self.alert("Network Error", message: "Could not retrieve data from warmshowers. Please try logging out and loggin in again")
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
            
            if error != nil {
                
                self.errorAlert(error!)
                doWithLogoutResponse(success: false)
                return
                
            } else if response != nil {
                
                if let json = self.jsonDataToJSONObject(data!) {
                    print("Logout request responded with: \(json)")
                    doWithLogoutResponse(success: true)
                    return
                } else {
                    
                    // handle http errors
                    let httpResponse = response as! NSHTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    print("Logout request responded with: \(httpResponse)")
                    if statusCode > 200 {
                        if statusCode == 406 {
                            // http 406: unauthorized. The user was already logged out
                            doWithLogoutResponse(success: true)
                            return
                        } else {
                            self.httpErrorAlert(data!, response: httpResponse)
                            doWithLogoutResponse(success: false)
                            return
                        }
                    }
                }
            }
        })
    }
    
    // To update a map with annotations marking warmshowers member locations
    func getHostDataForMapView(map: MKMapView, withHostData: (data: NSData?) -> Void) {
        
        let params = map.getWSMapRegion(LIMIT)
        
        requestWithCSRFToken(WSURL.LOCATION_SEARCH() , type: "POST", params: params, doWithResponse: { (data, response, error) -> Void in
            
            
            self.errorHandler(data!, response: response, error: error)
            withHostData(data: data)
            
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
                alert("Error", message: "Failed converting JSON data.")
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
