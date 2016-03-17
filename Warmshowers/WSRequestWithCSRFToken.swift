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
    var token: String? {
        get {
            return tokenGetter.token
        }
        set(newToken) {
            tokenGetter.token = newToken
        }
    }
    
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
        // Abort if:
        //  1. The task has already been tried once
        //  2. The task has been cancelled
        //  3. The server returned a 401 or 403.
        if !finalAttempt
            && task?.state != .Canceling
            && (httpResponse?.statusCode == 401 || httpResponse?.statusCode == 403 || httpResponse?.statusCode == 406)
        {
            finalAttempt = true
            return true
        } else {
            return false
        }
    }
    
    override func retryReqeust() {
        // Set up the login manager and try again
        loginManager.login()
    }
    
    // Resets the upater variables
    override func reset() {
        finalAttempt = false
        token = nil
        error = nil
    }
    
    // Cancels downloads and data parsing
    //
    override func cancel() {
        task?.cancel()
        task = nil
        token = nil
        end()
    }

}