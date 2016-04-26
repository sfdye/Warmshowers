//
//  WSCreateFeedbackEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSCreateFeedbackEndPoint : WSAPIEndPointProtocol {
    
    static let sharedEndPoint = WSCreateFeedbackEndPoint()
    
    var type: WSAPIEndPoint { return .CreateFeedback }
    
    var path: String { return "/services/rest/node" }
    
    var method: HttpMethod { return HttpMethod.Post }
    
    var successCodes: Set<Int> { return [200] }
    
    func request(request: WSAPIRequest, shouldParseDataWithResponse response: NSURLResponse?) -> Bool {
        print("Got response with code: \((response as! NSHTTPURLResponse).statusCode)")
        return (response as! NSHTTPURLResponse).statusCode == 200
    }
    
    func doesExpectDataWithResponse() -> Bool {
        return true
    }
    
    func request(request: WSAPIRequest, needsToParseJSON json: AnyObject) throws {
        // No need to parse response.
    }
    
    func generateMockResponseForURLRequest(urlRequest: NSMutableURLRequest) -> (NSData?, NSURLResponse?, NSError?) {
        let data = NSData()
        let response = NSURLResponse()
        return (data, response, nil)
    }
    
}