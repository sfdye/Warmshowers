//
//  WSRequestWithCSRFToken.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

// Base class that manages requesting a CSRF token and then executing a data request
//
class WSRequestWithCSRFToken : WSRequester {
    
    var tokenGetter = WSCSRFTokenGetter()
    var token: String? { return tokenGetter.token }
    
    override init() {
        super.init()
        
        // Set the token getter to execute the request if a token was recieved
        tokenGetter.success = { self.start() }
        tokenGetter.failure = self.failure
    }
    
    // Prevents the request starting without a CSRF token
    //
    override func shouldStart() -> Bool {
        if token == nil {
            error = NSError(domain: "WSRequesterDomain", code: 9, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Request aborted with no CSRF token", comment: "")])
            return false
        } else {
            return true
        }
    }
    
    override func shouldRetryRequest() -> Bool {
        if !finalAttempt {
            finalAttempt = true
            return true
        } else {
            return false
        }
    }
    
    override func retryReqeust() {
        print("retrying")
        // Set up the login manager and try again
        loginManager.success = {
            self.tokenGetter.start()
        }
        loginManager.failure = {
            self.error = self.loginManager.error
            self.end()
        }
        loginManager.start()
    }

}