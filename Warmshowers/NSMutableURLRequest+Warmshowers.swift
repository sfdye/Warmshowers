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
    func setBodyContent(_ params: [String: String]) {
        
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
        
        self.httpBody = requestBodyAsString.data(using: String.Encoding.utf8)
    }
    
    // Initialises a NSMutableURLRequest for a particular Warmshowers Restful service
    //
    class func mutableURLRequestForEndpoint(_ endPoint: WSAPIEndPointProtocol, withPostParameters params: [String: String]? = nil) throws -> NSMutableURLRequest {
        
        if endPoint.type == .imageResource {
            if let url = URL(string: endPoint.path) {
                return NSMutableURLRequest(url: url)
            } else {
                throw WSAPICommunicatorError.invalidImageResourceURL
            }
        }
        
        let request = NSMutableURLRequest.init()
        request.url = try! WSURL.BASE.appendingPathComponent(endPoint.path)
        request.httpMethod = endPoint.method.rawValue
        request.addValue(endPoint.accept.rawValue, forHTTPHeaderField: "Accept")
        
        if (endPoint.type != .login && endPoint.type != .token) {
            
            let (sessionCookie, token, _) = WSSessionState.sharedSessionState.getSessionData()
            
            guard sessionCookie != nil else {
                throw WSAPICommunicatorError.noSessionCookie
            }
            
            guard token != nil else {
                throw WSAPICommunicatorError.noToken
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

}
