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
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/session/token")
    }
    
    func request(_ request: WSAPIRequest, didRecieveResponseWithText text: String) throws -> Any? {
        WSSessionState.sharedSessionState.setToken(text)
        return text
    }
    
}
