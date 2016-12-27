//
//  TokenEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class TokenEndPoint: APIEndPointProtocol {
    
    var type: APIEndPoint = .token
    
    var acceptType: ContentType = .plainText
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/session/token")
    }
    
    func request(_ request: APIRequest, didRecieveResponseWithText text: String) throws -> Any? {
//        SessionState.sharedSessionState.set(token: text)
        assertionFailure("Check this")
        return text
    }
    
}
