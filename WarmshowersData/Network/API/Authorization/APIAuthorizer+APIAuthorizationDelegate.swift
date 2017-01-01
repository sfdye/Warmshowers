//
//  APIAuthorizer+APIAuthorizationDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

extension APIAuthorizer: APIAuthorizationDelegate {
    
    public func authorizedURLRequest(fromAPIRequest request: APIRequest, withSecureStore secureStore: SecureStoreDelegate) throws -> URLRequest {
        
        if request.endPoint.type != .login && request.endPoint.type != .token && currentlyReauthorizing {
            throw APIAuthorizerError.currentlyReauthorizing
        }
        
        let hostURL = try request.delegate.hostURLForRequest(request)
        let url = try request.endPoint.url(withHostURL: hostURL, andParameters: request.parameters)
        
        // URL Request
        let urlRequest = NSMutableURLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        // Add header parameters
        urlRequest.addValue(request.endPoint.acceptType.rawValue, forHTTPHeaderField: "Accept")
        
        // Add body parameters.
        if outboundDataMethods.contains(request.method) {
            urlRequest.httpBody = try request.endPoint.httpBody(fromData: request.data, forMethod: request.method, withEncoder: ParameterEncoding())
            if let contentType = request.endPoint.contentType(forMethod: request.method)?.rawValue {
                urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            } else {
                assertionFailure("A valid content type must be specified for requests with body parameters.")
            }
        }
        
        // Login requests do not require authorization
        guard request.endPoint.type != .login else {
            return urlRequest as URLRequest
        }
        
        // Authorise the request.
        var token: String, sessionCookie: String
        do {
            (token, sessionCookie) = try secureStore.getTokenAndSecret()
        } catch {
            throw APIAuthorizerError.invalidAuthorizationData
        }
        
        // Add the session cookie to the header.
        urlRequest.addValue(sessionCookie, forHTTPHeaderField: "Cookie")
        
        // Add the CSRF token to the header.
        urlRequest.addValue(token, forHTTPHeaderField: "X-CSRF-Token")
        
        return urlRequest as URLRequest
    }
    
}
