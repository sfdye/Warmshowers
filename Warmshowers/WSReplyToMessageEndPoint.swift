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
    
    func HTTPBodyWithData(data: AnyObject?) throws -> String {
        guard let reply = data as? WSReplyMessageData else { throw WSAPIEndPointError.InvalidOutboundData }
        var params = [String: String]()
        params["thread_id"] = String(reply.threadID)
        params["body"] = reply.body
        return HttpBody.bodyStringWithParameters(params)
    }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        // Check for success in response
        return nil
    }
}