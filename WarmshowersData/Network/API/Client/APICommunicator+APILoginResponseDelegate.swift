//
//  APICommunicator+APILoginResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

extension APICommunicator: APILoginResponseDelegate {
    
    func loginRequestDidSucceed(_ loginRequest: APILoginRequest) {
        // After login or when access tokens are refreshed ensure any queued requests are executed.
        executeQueuedRequests()
    }
    
    func loginRequest(_ loginRequest: APILoginRequest, didFailWithError error: Error) {
        // No response required.
        log("Login already in progress.")
    }
    
}
