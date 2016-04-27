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
    
    var type: WSAPIEndPoint { return .Token }
    
    var path: String { return "/services/session/token" }
    
    var method: HttpMethod { return .Get }
    
    var accept: AcceptType { return .PlainText }
    
    func request(request: WSAPIRequest, didRecievedResponseWithText text: String) throws {
        WSSessionData.setToken(text)
    }
    
    func generateMockResponseForURLRequest(urlRequest: NSMutableURLRequest) -> (NSData?, NSURLResponse?, NSError?) {
        let data = NSData()
        let response = NSURLResponse()
        return (data, response, nil)
    }
}