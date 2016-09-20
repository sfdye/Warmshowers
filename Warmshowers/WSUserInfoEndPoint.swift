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
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        guard let uidString = parameters as? NSString else { throw WSAPIEndPointError.invalidPathParameters }
        return hostURL.appendingPathComponent("/services/rest/user/\(uidString)")
    }
    
    func request(_ request: WSAPIRequest, didRecieveResponseWithJSON json: Any) throws -> Any? {
        guard let userInfo = WSUser(json: json) else { throw WSAPIEndPointError.parsingError(endPoint: name, key: nil) }
        return userInfo
    }
    
}
