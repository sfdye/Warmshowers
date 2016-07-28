//
//  WSMarkMessageEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSMarkThreadReadEndPoint: WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .MarkThreadRead
    
    var httpMethod: HttpMethod = .Post
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        return hostURL.URLByAppendingPathComponent("/services/rest/message/markThreadRead")
    }
    
    func HTTPBodyParametersWithData(data: AnyObject?) throws -> [String: String] {
        guard let readState = data as? WSMessageThreadReadState else { throw WSAPIEndPointError.InvalidOutboundData }
        var params = [String: String]()
        params["thread_id"] = String(readState.threadID)
        params["status"] = String(readState.read ? 0 : 1)
        return params
    }
    
    func request(request: WSAPIRequest, didRecieveResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
        // Successful requests get a response with "1" in the body
        if json.count == 1 {
            if let success = json.objectAtIndex(0) as? Bool {
                return success
            }
        }
        
        return nil
    }
}