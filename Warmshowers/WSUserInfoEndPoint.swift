//
//  WSUserInfoEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSUserInfoEndPoint: WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .UserInfo
    
    var httpMethod: HttpMethod = .Get
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        assertionFailure("path needs uid")
        return hostURL.URLByAppendingPathComponent("/services/rest/user/<UID>")
    }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        return json
    }
}