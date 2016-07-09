//
//  WSMarkMessageEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSMarkMessageEndPoint: WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .MarkMessage
    
    var httpMethod: HttpMethod = .Post
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        return hostURL.URLByAppendingPathComponent("/services/rest/message/markThreadRead")
    }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
        // Successful requests get a response with "1" in the body
        if json.count == 1 {
            if let success = json.objectAtIndex(0) as? Bool {
                return success
            }
        }
        return nil
    }
}