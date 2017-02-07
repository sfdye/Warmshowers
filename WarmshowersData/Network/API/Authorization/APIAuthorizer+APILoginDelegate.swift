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
        
        guard !isCurrentlyAuthorizing else {
            requester.loginRequest(loginRequest, didFailWithError: APILoginError.loginAlreadyInProgress)
            return
        }
        
        isCurrentlyAuthorizing = true
        
        api.contact(endPoint: .login, withMethod: .post, andPathParameters: nil, andData: loginRequest, thenNotify: self, ignoreCache: true)
    }
    
}
