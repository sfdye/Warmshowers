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
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        // Check for success in response
        return nil
    }
}