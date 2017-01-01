//
//  TokenEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

// CHANGE BACK TO STRUCT WHEN FINISHED DEBUGGING.
class TokenEndPoint: APIEndPointProtocol {
    
    // DEBUG
    var lastTokenReceived: Date = Date()
    //
    
    var type: APIEndPoint = .token
    
    var acceptType: ContentType = .plainText
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/session/token")
    }
    
    func request(_ request: APIRequest, didRecieveResponseWithText text: String) throws -> Any? {
        
        // DEBUG
        print("Last token received at \(lastTokenReceived). New token recieved no (\(Date())).")
        print("Interval: \(Date().timeIntervalSince(lastTokenReceived))")
        self.lastTokenReceived = Date()
        //
        
        let newToken = text
        
        let (_, secret) = try DataDelegates.shared.secureStore.getTokenAndSecret()
        
        try DataDelegates.shared.secureStore.setToken(newToken, andSecret: secret)
        return text
    }
    
}
