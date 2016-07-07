//
//  WSUserInfoEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSUserInfoEndPoint: WSAPIEndPointProtocol {
    
    static let sharedEndPoint = WSUserInfoEndPoint()
    
    var type: WSAPIEndPoint {
        assertionFailure("path needs uid")
        return .UserInfo }
    
    var path: String { return "/services/rest/user/<UID>" }
    
    var method: HttpMethod { return .Get }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        return json
    }
}