//
//  WSRequests.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

protocol WSRequestAlert {
    func presentAlert(alert: UIAlertController)
}

class WSRequest {
    
    var alertViewController : WSRequestAlert?
    
    let session = NSURLSession.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    
    // MARK: - Error handlers
    
    // General error handler
    func errorHandler(error: NSError) {
        alert("Error", message: error.localizedDescription)
    }
    
    // Handles http error codes
    func httpErrorHandler(response: NSHTTPURLResponse) {
        
        var title = ""
        var message = ""
        let statusCode = response.statusCode
        
        switch statusCode {
        case 401:
            title = "Invalid Login"
            message = "There was an error with your E-Mail/Password combination. Please try again."
            break
        default:
            title = "Network Error"
            message = "Sorry, an unknown error has occured"
        }
        
        alert(title, message: message)
        
    }
    
    
    // MARK: - Alert functions
    
    func alert(title: String, message: String, handler: ((UIAlertAction) -> (Void))? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: handler))
        
        self.alertViewController?.presentAlert(alertController)
        
    }

    
    // MARK: - HTTP Request functions
    
    // Create a request
    func makeRequest(url: NSURL, type: String, params: (Dictionary<String, String>)? = nil) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest.init()
        request.URL = url
        request.HTTPMethod = type
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //        request.addValue(session_name + "=" + sessid, forHTTPHeaderField: "Cookie")
        if params != nil {
            request.setBodyContent(params!)
        }
        return request
    }
    
    // General request function
    func dataRequest(request: NSMutableURLRequest, success: (NSData?) -> Void) {
        
        let task = self.session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            
            if error != nil {
                
                // error
                self.errorHandler(error!)
            
            } else if response != nil {
                
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
                    success(data)
                } else {
                    // no data
                    self.alert("Error", message: "No data recieved from the server.")
                }
                
            } else {
                
                // no response
                self.alert("Error", message: "No response.")
                
            }
        })
            
        task.resume()
            
    }

    
//    let task = session.dataTaskWithRequest(<#T##request: NSURLRequest##NSURLRequest#>, completionHandler: <#T##(NSData?, NSURLResponse?, NSError?) -> Void#>)
//    
//    // Create a post request
//    class func requestWithCSRFToken(request: NSMutableURLRequest, params: (Dictionary<String, String>)? = nil, completion: (data: AnyObject?, response: AnyObject?, error: NSError?)) {
//        
//        self.getXCSRFTokenForRequest(request) { (token, error) -> () in
//            
//            if error != nil {
//                // error getting token
//                
//            } else if token != nil {
//                
//                // got a token, make the request
//                
//                
//            } else {
//                // no error, but no token
//            }
//        }
//    }
    
    
    //++++++++++++++++++
    
//    // got token, make the request
//    request.addValue(token!, forHTTPHeaderField: "X-CSRF-Token")
//    
//    let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
//        
//        if error != nil {
//            completion(data: nil, response: nil, error: error)
//        }
//        else if response != nil {
//            
//            let httpResponse = response as! NSHTTPURLResponse
//            if httpResponse.statusCode > 200 {
//                // http error
//                completion(data: nil, response: httpResponse, error: nil)
//            } else {
//                // http success
//                do {
//                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
//                    print(json)
//                    completion(data: json, response: response, error: nil)
//                }
//                catch {
//                    print("Unable to convert data to json")
//                    completion(data: nil, response: nil, error: nil)
//                }
//            }
//            
//        } else {
//            // no response from the server
//            completion(data: nil, response: nil, error: nil)
//        }
//        
//    })
    
    //++++++++++++++++
    
    
    
//    // Create a get request
//    func getRequest(url: NSURL) -> NSMutableURLRequest {
//        let request = NSMutableURLRequest.init()
//        request.URL = url
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.HTTPMethod = "GET"
//        return request
//    }
//    
//    func requestWithCSRFToken(url: NSURL) -> NSMutableURLRequest {
//        // get a CSRF Token from warmshowers.org
//        let request = NSMutableURLRequest.init()
//        request.URL = url
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.HTTPMethod = "GET"
//        return request
//    }
//    
//    class func getXCSRFTokenForRequest(request: NSURLRequest, completion: (data: NSData?, response: NSURLResponse?, error: NSError?)) {
//        let request = sharedInstance.getRequest(WSURL.TOKEN())
//        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
//            completion(data, response: response, error: error)
//            
//            if error != nil
//            {
//                // error getting the token
//                completion(token: nil, error: error)
//            }
//            else if data != nil
//            {
//                if let token = String(data: data!, encoding: NSUTF8StringEncoding)
//                {
//                    // got and decoded the token
//                    completion(token: token, error: nil)
//                }
//                else
//                {
//                    completion(token: nil, error: nil)
//                }
//            }
//        })
//        task.resume()
//    }
//    
    func login(username: String, password: String, success: (data: NSData?) -> Void) {
        // assemble the request
        let params = ["username" : username, "password" : password]
        let request = self.makeRequest(WSURL.LOGIN(), type: "POST", params: params)
        
        print("Login request sent")
        
        self.dataRequest(request) { (data) -> Void in
            if data != nil {
                success(data: data)
            }
        }
        
//        // create the data task
//        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
//            if error != nil {
//                completion(data: nil, response: nil, error: error)
//            }
//            else if response != nil {
//                let httpResponse = response as! NSHTTPURLResponse
//                if httpResponse.statusCode > 200 {
//                    // http error
//                    completion(data: nil, response: httpResponse, error: nil)
//                } else {
//                    // http success
//                    do {
//                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
//                        print(json)
//                        completion(data: json, response: response, error: nil)
//                    }
//                    catch {
//                        print("Unable to convert data to json")
//                        completion(data: nil, response: nil, error: nil)
//                    }
//                }
//            } else {
//                // no response from the server
//                completion(data: nil, response: nil, error: nil)
//            }
//        })
//        task.resume()
    }
    
//    class func logout(completion: (data: AnyObject?, response: AnyObject?, error: NSError?)->()) {
//        // assemble the request
//        let request = sharedInstance.postRequestWithCSRFToken(WSURL.LOGOUT)
//        // create the data task
//        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
//            if error != nil {
//                completion(data: nil, response: nil, error: error)
//            }
//            else if response != nil {
//                let httpResponse = response as! NSHTTPURLResponse
//                if httpResponse.statusCode > 200 {
//                    // http error
//                    completion(data: nil, response: httpResponse, error: nil)
//                } else {
//                    // http success
//                    do {
//                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
//                        print(json)
//                        completion(data: json, response: response, error: nil)
//                    }
//                    catch {
//                        print("Unable to convert data to json")
//                        completion(data: nil, response: nil, error: nil)
//                    }
//                }
//            } else {
//                // no response from the server
//                completion(data: nil, response: nil, error: nil)
//            }
//        })
//        task.resume()
//    }
    
    
    
    //    class func getUserInfo(uid: Int, completion: (data: AnyObject?, response: AnyObject?, error: NSError?)->()) {
    //        WSRequest().getXCSRFToken { (token, error) -> () in
    //            if error != nil
    //            {
    //                completion(data: nil, response: nil, error: error)
    //            } else if token != nil
    //            {
    //                // build theh url
    //                let url = WSRequest().USER_INFO_URL_BASE.URLByAppendingPathComponent(String(uid))
    //                // assemble the request
    //                let request = WSRequest().getRequest(url)
    //                session.dataTaskWithRequest(request: request, completionHandler: { (data, response, error) -> Void in
    //                    // pass on the data to the provided callback
    //                    completion(data: data, response: response, error: error)
    //                })
    //            } else
    //            {
    //                completion(data:nil, response: nil, error: error)
    //            }
    //        }
    //    }
    
    
    
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
