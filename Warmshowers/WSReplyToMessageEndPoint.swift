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
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/message/reply")
    }
    
    func HTTPBodyParameters(withData data: Any?) throws -> [String: String] {
        guard let reply = data as? WSReplyMessageData else { throw WSAPIEndPointError.invalidOutboundData }
        var params = [String: String]()
        params["thread_id"] = String(reply.threadID)
        params["body"] = reply.body
        return params
    }
    
    func request(_ request: WSAPIRequest, didRecieveResponseWithJSON json: Any) throws -> Any? {
        // Check for success in response
        return nil
    }
}
