//
//  WSRequestWithCSRFToken.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSRequestWithCSRFToken : WSDataDownloader {
    
    var tokenGetter = WSCSRFTokenGetter()
    
    override init() {
        super.init()
        
        // Set the token getter to execute the request if a token was recieved
        tokenGetter.success = {
            guard self.tokenGetter.token != nil else {
                self.failure?()
                return
            }
            self.request()
        }
        tokenGetter.failure = self.failure
    }
    
    // Starts the request
    //
    func start() {
        tokenGetter.start()
    }
    
    // The request to execute if a token was recieved
    //
    func request() {
        
    }
    
//    // Checks for CSRF failure message
//    //
//    func hasFailedCSRF(data: NSData) -> Bool {
//        
//        do {
//            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
//            // Needed this line otherwise app would crash trying to index larger json
//            if json.count == 1 {
//                let responseBody = json.objectAtIndex(0) as? String
//                if responseBody?.lowercaseString.rangeOfString("csrf validation failed") != nil {
//                    return true
//                }
//            }
//        } catch {
//            print("Could not match CSRF failure message in response body.")
//        }
//        return false
//    }
    
    
}