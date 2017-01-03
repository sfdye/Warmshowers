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
            print("Login already in progress.")
            return
        }
        
        print("Login started")
        currentlyReauthorizing = true
        
        do {
            print("Checking for session cookie.")
            let (_, _) = try secureStore.getTokenAndSecret()
            print("Refreshing token")
            api.contact(endPoint: .token, withMethod: .post, andPathParameters: nil, andData: loginRequest, thenNotify: self)
        } catch {
            print("Login in with username and password.")
            api.contact(endPoint: .login, withMethod: .post, andPathParameters: nil, andData: loginRequest, thenNotify: self)
        }
        
//        api.contact(endPoint: .login, withMethod: .post, andPathParameters: nil, andData: loginRequest, thenNotify: self)
    }
    
}
