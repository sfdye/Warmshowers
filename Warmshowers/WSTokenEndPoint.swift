//
//  WSTokenEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSTokenEndPoint : WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .Token
    
    var httpMethod: HttpMethod = .Get
    
    var acceptType: AcceptType = .PlainText
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        return hostURL.URLByAppendingPathComponent("/services/session/token")
    }
    
    func request(request: WSAPIRequest, didRecievedResponseWithText text: String) throws -> AnyObject? {
        WSSessionState.sharedSessionState.setToken(text)
        return text
    }
    
}