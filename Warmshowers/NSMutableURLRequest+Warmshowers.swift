//
//  NSMutableURLRequest+Warmshowers.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

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
    class func mutableURLRequestForEndpoint(endPoint: WSAPIEndPointProtocol, withPostParameters params: [String: String]? = nil) throws -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest.init()
        request.URL = WSURL.BASE.URLByAppendingPathComponent(endPoint.path)
        request.HTTPMethod = endPoint.method.rawValue
        request.addValue(endPoint.accept.rawValue, forHTTPHeaderField: "Accept")
        print(endPoint.type)
        if (endPoint.type != .Login && endPoint.type != .Token) {
            // Add the session cookie to the header.
            do {
                let sessionCookie = try WSSessionData.getSessionCookie()
                request.addValue(sessionCookie, forHTTPHeaderField: "Cookie")
            } catch {
                throw WSAPICommunicatorError.NoSessionCookie
            }
            // Add the CSRF token to the header.
            // Note: Your not meant to need a CSRF token for login, but if you dont get one sometimes login authentication fails ...
            do {
                let token = try WSSessionData.getToken()
                request.addValue(token, forHTTPHeaderField: "X-CSRF-Token")
            } catch {
                throw WSAPICommunicatorError.NoToken
            }
        }

        if let params = params where endPoint.method == .Post {
            request.setBodyContent(params)
        }
        
        return request
    }
    
    
    // KEEP FOR LEGACY UNTIL HTTP CLIENT TRANSER IS COMPLETE
    class func withWSRestfulService(service: WSRestfulService) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest.init()
        request.URL = service.url
        request.HTTPMethod = service.methodAsString
        
        if service.type == .Token {
            request.addValue("text/plain", forHTTPHeaderField: "Accept")
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        return request
    }}