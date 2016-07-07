//
//  WSAPIEndPointProtocol+Defaults.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

// Protocol defaults
extension WSAPIEndPointProtocol {
    
    var accept: AcceptType { return .JSON }
    
    var successCodes: Set<Int> { return [200] }
    
    func doesExpectDataWithResponse() -> Bool { return true }
    
    func request(request: WSAPIRequest, didRecievedResponseWithText text: String) throws -> AnyObject? { return nil }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? { return nil }
    
    func generateMockResponseForURLRequest(urlRequest: NSMutableURLRequest) -> (NSData?, NSURLResponse?, NSError?) {
        return (nil, nil, nil)
    }
}