//
//  APIAuthorizer+APIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

extension APIAuthorizer: APIResponseDelegate {
    
    func request(_ request: APIRequest, didSucceedWithData data: Any?) {
        
        guard let loginRequest = request.data as? APILoginRequest else {
            assertionFailure("Attempted to use a login or token end point without APILoginRequest as the request data.")
            return
        }
        
        // 1. Recieved login response: request a token
        if request.endPointType == .login {
            
            guard let uid = data as? Int else {
                currentlyReauthorizing = false
                loginRequest.requester.loginRequest(loginRequest, didFailWithError: APILoginError.invalidUIDRecieved)
                return
            }
            
            // Update the login request.
            loginRequest.uid = uid
            
            // Request an access token.
            api.contact(endPoint: .token, withMethod: .get, andPathParameters: nil, andData: loginRequest, thenNotify: self, ignoreCache: true)
            return
        }
        
        // 2. Recieved the access token: notifiy the requester.
        currentlyReauthorizing = false
        loginRequest.requester.loginRequestDidSucceed(loginRequest)
        delegate?.loginRequestDidSucceed(loginRequest)
    }
    
    func request(_ request: APIRequest, didFailWithError error: Error) {
        
        guard let loginRequest = request.data as? APILoginRequest else {
            assertionFailure("Attempted to use a login or token end point without APILoginRequest as the request data.")
            return
        }
        
        var loginError = error
        
        // Update the error if appropriate.
        switch error {
        case APICommunicatorError.serverError(let statusCode, _):
            if statusCode == 401 {
                loginError = APILoginError.invalidCredentials
            }
        default:
            break
        }
        
        currentlyReauthorizing = false
        loginRequest.requester.loginRequest(loginRequest, didFailWithError: loginError)
    }
    
}

extension APIAuthorizer {
    
    func loginRequestDidSucceed(_ loginRequest: APILoginRequest) {
        
    }
    
    func loginRequest(_ loginRequest: APILoginRequest, didFailWithError error: Error) {
        
    }
    
}
