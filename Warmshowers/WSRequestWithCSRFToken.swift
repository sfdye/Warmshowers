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
    
    override func shouldRetryRequest() -> Bool {
        if !finalAttempt {
            finalAttempt = true
            return true
        } else {
            return false
        }
    }
    
    override func retryReqeust() {
        // Set up the login manager and try again
        loginManager.success = {
            self.tokenGetter.start()
        }
        loginManager.failure = {
            self.error = self.loginManager.error
        }
        loginManager.start()
    }
    
    // Starts the request
    //
    override func shouldStart() -> Bool {
        return token != nil
    }

}