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
    
    func request(_ request: WSAPIRequest, didRecievedResponseWithText text: String) throws -> AnyObject? { return nil }
    
    func request(_ request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? { return nil }
    
    func generateMockResponseForURLRequest(_ urlRequest: NSMutableURLRequest) -> (Data?, URLResponse?, NSError?) {
        return (nil, nil, nil)
    }
}
