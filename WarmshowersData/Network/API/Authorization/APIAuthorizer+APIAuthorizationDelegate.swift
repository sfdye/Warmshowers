//
//  APIAuthorizer+APIAuthorizationDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

extension APIAuthorizer: APIAuthorizationDelegate {
    
    func canAuthorize(_ request: APIRequest) -> Bool {
        return !isCurrentlyAuthorizing || request.endPointType == .login || request.endPointType == .token
    }
    
    public func authorizedURLRequest(fromAPIRequest request: APIRequest, withSecureStore secureStore: SecureStoreDelegate) throws -> URLRequest {
        
        if request.endPoint.type != .login && request.endPoint.type != .token && isCurrentlyAuthorizing {
            throw APIAuthorizerError.currentlyReauthorizing
        }
        
        var urlRequest = try APIRequest.urlRequest(fromRequest: request)
        
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
        
        return urlRequest
    }
    
}
