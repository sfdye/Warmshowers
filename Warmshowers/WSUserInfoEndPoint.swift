//
//  WSUserEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSUserEndPoint: WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .UserInfo
    
    var httpMethod: HttpMethod = .Get
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        guard let uidString = parameters as? NSString else { throw WSAPIEndPointError.InvalidPathParameters }
        return hostURL.URLByAppendingPathComponent("/services/rest/user/\(uidString)")
    }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        print(json)
        guard let userInfo = WSUser(json: json) else { throw WSAPIEndPointError.ParsingError(endPoint: name, key: nil) }
        return userInfo
    }
    
}