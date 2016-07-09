//
//  WSReplyToMessageEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSReplyToMessageEndPoint: WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .ReplyToMessage
    
    var httpMethod: HttpMethod = .Post
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        return hostURL.URLByAppendingPathComponent("/services/rest/message/reply")
    }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        // Check for success in response
        return nil
    }
}