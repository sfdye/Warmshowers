//
//  WSRequests.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

protocol WSRequestAlert {
    func requestAlert(title: String, message: String)
}

class WSRequest {
    
    var alertViewController : WSRequestAlert?
    
    let session = NSURLSession.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    
    // MARK: - Error handlers
    
    // General error handler
    func errorHandler(error: NSError) {
        if alertViewController != nil {
            self.alert("Error", message: error.localizedDescription)
        }
    }
    
    // Handles http error codes
    func httpErrorHandler(response: NSHTTPURLResponse) {
        
        if alertViewController != nil {
            
            let statusCode = response.statusCode
            let title = "Network Error"
            let message = "HTTP " + String(statusCode)
            
            self.alert(title, message: message)
            
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
    func makeRequest(url: NSURL, type: String, params: (Dictionary<String, String>)? = nil, token: String? = nil) -> NSMutableURLRequest {
        
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
    func dataRequest(request: NSMutableURLRequest, doWithReturnedData: (NSData?) -> Void) {
        
        let task = self.session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            
            if error != nil {
                
                // error
                self.errorHandler(error!)
                return
                
            }
            
            if response != nil {
                
                // got response, check for http errors
                
                // http error
                let httpResponse = response as! NSHTTPURLResponse
                if httpResponse.statusCode > 200 {
                    self.httpErrorHandler(httpResponse)
                    return
                }
                
                // handle data
                if data != nil {
                    // got some data
                    doWithReturnedData(data)
                    return
                }
                
            }
                
            // no response or data is nil
            self.alert("Error", message: "No response or data.")
            
        })

        task.resume()
            
    }
    
    // For making requests that require a X_CSRF token in the header
    func requestWithCSRFToken(url: NSURL, type: String, params: (Dictionary<String, String>)? = nil, doWithReturedData: (NSData?) -> Void) -> Void {
        
        // get a X-CSRF Token from warmshowers.org
        let tokenRequest = makeRequest(WSURL.TOKEN(), type: "GET")
        
        dataRequest(tokenRequest) { (tokenData) -> Void in
            
            if let token = String.init(data: tokenData!, encoding: NSUTF8StringEncoding) {
                
                let request = self.makeRequest(url, type: type, params: params, token: token)
                
                // make the actual request
                print("Making a request to \(request.URL!) with token \(token)")
                self.dataRequest(request, doWithReturnedData: doWithReturedData)
            }
        }
    }
    
    
    // MARK: - Warmshowers RESTful API requests
    
    func login(username: String, password: String, doWithLoginData: (data: NSData?) -> Void) {

        let params = ["username" : username, "password" : password]
        let request = self.makeRequest(WSURL.LOGIN(), type: "POST", params: params)
        dataRequest(request, doWithReturnedData: doWithLoginData)
        
    }
    
    func logout(doWithLogoutResponse: (wasLoggedIn: Bool) -> Void) {

        requestWithCSRFToken(WSURL.LOGOUT(), type: "POST", doWithReturedData : { (data) -> Void in
            
            if data != nil {
                
                let json = self.jsonDataToDictionary(data!)
                
                if json != nil {
                    
                    let response = json!.objectAtIndex(0)
                    print(response)
                    
                    if response as! Int == 1 {
                        doWithLogoutResponse(wasLoggedIn: true)
                        return
                    }
                }
            }
            
            doWithLogoutResponse(wasLoggedIn: false)
        })
    }
    
    
    // MARK: - Utilities
    
    // Convert NSData to a json dictionary
    func jsonDataToDictionary(data: NSData?) -> AnyObject? {
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            return json
        } catch {
            return nil
        }
        
    }
    
}
    
// To create NSMutableRequests with a dictionary of post parameters
extension NSMutableURLRequest {
    
    func setBodyContent(params: Dictionary<String, String>) {
        
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
