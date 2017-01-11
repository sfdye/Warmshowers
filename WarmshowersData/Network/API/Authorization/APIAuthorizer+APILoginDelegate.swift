//
//  APIAuthorizer+APILoginDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

extension APIAuthorizer: APILoginDelegate, DataSource {
    
    func login(withUsername username: String, andPassword password: String, thenNotify requester: APILoginResponseDelegate) {
        let loginRequest = APILoginRequest(username: username, password: password, requester: requester)
        
        guard !currentlyReauthorizing else {
            requester.loginRequest(loginRequest, didFailWithError: APILoginError.loginAlreadyInProgress)
            return
        }
        
        currentlyReauthorizing = true
        
        do {
            // Checking for a session cookie.
            let (_, _) = try secureStore.getTokenAndSecret()
            // Refresh the CSRF token
            api.contact(endPoint: .token, withMethod: .get, andPathParameters: nil, andData: loginRequest, thenNotify: self, ignoreCache: true)
        } catch {
            // Login again if there is no session cookie.
            api.contact(endPoint: .login, withMethod: .post, andPathParameters: nil, andData: loginRequest, thenNotify: self, ignoreCache: true)
        }
        
    }
    
}
