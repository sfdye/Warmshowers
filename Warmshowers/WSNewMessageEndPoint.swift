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
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        return hostURL.URLByAppendingPathComponent("/services/rest/message/send")
    }
    
    func HTTPBodyParametersWithData(data: AnyObject?) throws -> [String: String] {
        guard let message = data as? WSNewMessageData else { throw WSAPIEndPointError.InvalidOutboundData }
        var params = [String: String]()
        params["recipients"] = message.recipientsString
        params["subject"] = message.subject
        params["body"] = message.body
        return params
    }
    
    func request(request: WSAPIRequest, didRecieveResponseWithJSON json: AnyObject) throws -> AnyObject? {
        // Check for success in response
        return nil
    }
}