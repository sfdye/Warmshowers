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
    
    var tokenGetter: WSCSRFTokenGetter!
    lazy var loginManager: WSLoginManager = {
        let loginManager = WSLoginManager(
            success: { () -> Void in
                self.tokenGetter.start()
            },
            failure: { (error) -> Void in
                self.error = error
                self.end()
            }
        )
        return loginManager
    }()
    var token: String? { return tokenGetter.token }
    
    // Login manager for getting a new session cookie if required
    lazy var finalAttempt = false
    
    override init(success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        super.init(success: success, failure: failure)
        // Set the token getter to execute the request if a token was recieved
        tokenGetter = WSCSRFTokenGetter(success: self.start, failure: failure)
    }
    
    // Prevents the request starting without a CSRF token
    //
    override func shouldStart() -> Bool {
        if token == nil {
            setError(102, description: "Request aborted with no CSRF token.")
            return false
        } else {
            return isReachable()
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
        // Set up the login manager and try again
        loginManager.start()
    }
    
    // Resets the upater variables
    override func reset() {
        finalAttempt = false
        error = nil
    }

}