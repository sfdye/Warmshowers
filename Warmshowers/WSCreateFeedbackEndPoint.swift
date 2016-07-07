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
    
    var method: HttpMethod { return .Post }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        // No need for response data.
        return nil
    }
    
    func generateMockResponseForURLRequest(urlRequest: NSMutableURLRequest) -> (NSData?, NSURLResponse?, NSError?) {
        let data = NSData()
        let response = NSURLResponse()
        return (data, response, nil)
    }
}