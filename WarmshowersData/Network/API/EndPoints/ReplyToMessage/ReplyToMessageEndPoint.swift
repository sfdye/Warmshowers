//
//  ReplyToMessageEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class ReplyToMessageEndPoint: APIEndPointProtocol {
    
    var type: APIEndPoint = .replyToMessage
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/message/reply")
    }
    
    func httpBody(fromData data: Any?, forMethod method: HTTP.Method, withEncoder encoder: APIRequestDataEncoder) throws -> Data? {
        
        guard let reply = data as? ReplyMessageData else {
            throw APIEndPointError.invalidOutboundData(endPoint: name, errorDescription: "The \(name) end point requires a ReplyMessageData object in the request data.")
        }
        
        var params = [String: String]()
        params["thread_id"] = String(reply.threadID)
        params["body"] = reply.body
        let body = try encoder.body(fromParameters: params)
        return body
    }
    
    func request(_ request: APIRequest, didRecieveResponseWithJSON json: Any, parser: JSONParser) throws -> Any? {
        // Check for success in response
        return nil
    }
}
