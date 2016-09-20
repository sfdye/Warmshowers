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
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/message/markThreadRead")
    }
    
    func HTTPBodyParameters(withData data: Any?) throws -> [String: String] {
        guard let readState = data as? WSMessageThreadReadState else { throw WSAPIEndPointError.invalidOutboundData }
        var params = [String: String]()
        params["thread_id"] = String(readState.threadID)
        params["status"] = String(readState.read ? 0 : 1)
        return params
    }
    
    func request(_ request: WSAPIRequest, didRecieveResponseWithJSON json: Any) throws -> Any? {
        
        guard let json = json as? [Any] else { return nil }
        
        // Successful requests get a response with "1" in the body
        if json.count == 1 {
            if let success = json[0] as? Bool {
                return success
            }
        }
        
        return nil
    }
}
