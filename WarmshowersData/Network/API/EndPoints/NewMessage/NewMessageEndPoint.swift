//
//  NewMessageEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct NewMessageEndPoint: APIEndPointProtocol {
    
    var type: APIEndPoint = .newMessage
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/message/send")
    }
    
    func httpBody(fromData data: Any?, forMethod method: HTTP.Method, withEncoder encoder: APIRequestDataEncoder) throws -> Data? {
        
        guard let message = data as? NewMessageData else {
            throw APIEndPointError.invalidOutboundData(endPoint: name, errorDescription: "The \(name) end point requires a NewMessageData object in the request data.")
        }
        
        var params = [String: String]()
        params["recipients"] = message.recipientsString
        params["subject"] = message.subject
        params["body"] = message.body
        let body = try encoder.body(fromParameters: params)
        return body
    }
    
     func request(_ request: APIRequest, didRecieveResponseWithJSON json: Any, parser: JSONParser) throws -> Any? {
        // Check for success in response
        return nil
    }
}
