//
//  WSTokenEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSTokenEndPoint : WSAPIEndPointProtocol {
    
    static let sharedEndPoint = WSTokenEndPoint()
    
    var type: WSAPIEndPoint { return .token }
    
    var path: String { return "/services/session/token" }
    
    var method: HttpMethod { return .Get }
    
    var accept: AcceptType { return .PlainText }
    
    func request(_ request: WSAPIRequest, didRecievedResponseWithText text: String) throws -> AnyObject? {
        WSSessionState.sharedSessionState.setToken(text)
        return text
    }
    
    func generateMockResponseForURLRequest(_ urlRequest: NSMutableURLRequest) -> (Data?, URLResponse?, NSError?) {
        assertionFailure("No testing data added")
        let data = Data()
        let response = URLResponse()
        return (data, response, nil)
    }
}
