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
        
        if (endPoint.type != .Login && endPoint.type != .Token) {
            
            let (sessionCookie, token, _) = WSSessionState.sharedSessionState.getSessionData()
            
            guard sessionCookie != nil else {
                throw WSAPICommunicatorError.NoSessionCookie
            }
            
            guard token != nil else {
                throw WSAPICommunicatorError.NoToken
            }
            
            // Add the session cookie to the header.
            request.addValue(sessionCookie!, forHTTPHeaderField: "Cookie")

            // Add the CSRF token to the header.
            request.addValue(token!, forHTTPHeaderField: "X-CSRF-Token")
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