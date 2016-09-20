//
//  WSNewMessageEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSNewMessageEndPoint: WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .NewMessage
    
    var httpMethod: HttpMethod = .Post
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/message/send")
    }
    
    func HTTPBodyParameters(withData data: Any?) throws -> [String: String] {
        guard let message = data as? WSNewMessageData else { throw WSAPIEndPointError.invalidOutboundData }
        var params = [String: String]()
        params["recipients"] = message.recipientsString
        params["subject"] = message.subject
        params["body"] = message.body
        return params
    }
    
    func request(_ request: WSAPIRequest, didRecieveResponseWithJSON json: Any) throws -> Any? {
        // Check for success in response
        return nil
    }
}
