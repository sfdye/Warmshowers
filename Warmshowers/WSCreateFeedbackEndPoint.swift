//
//  WSCreateFeedbackEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSCreateFeedbackEndPoint : WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .CreateFeedback
    
    var httpMethod: HttpMethod = .Post
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        return hostURL.URLByAppendingPathComponent("/services/rest/node")
    }
    
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