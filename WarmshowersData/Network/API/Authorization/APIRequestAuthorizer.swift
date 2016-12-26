//
//  APIRequestAuthorizer.swift
//  Powershop
//
//  Created by Rajan Fernandez on 14/07/16.
//  Copyright © 2016 Powershop. All rights reserved.
//

import Foundation

class APIRequestAuthorizer: APIAuthorizationDelegate {
    
    let outboundDataMethods: [HTTP.Method] = [.post, .put, .delete, .patch]
    
    public func authorizedURLRequest(fromAPIRequest request: APIRequest, withSecureStore secureStore: SecureStoreDelegate) throws -> URLRequest {

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
            
            // Authorise the request.
            let (token, sessionCookie) = try secureStore.getTokenAndSecret()
            
            // Add the session cookie to the header.
            urlRequest.addValue(sessionCookie, forHTTPHeaderField: "Cookie")
            
            // Add the CSRF token to the header.
            urlRequest.addValue(token, forHTTPHeaderField: "X-CSRF-Token")
            
            return urlRequest as URLRequest
    }

}

