//
//  WSNewMessageEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSNewMessageEndPoint: WSAPIEndPointProtocol {
    
    static let sharedEndPoint = WSNewMessageEndPoint()
    
    var type: WSAPIEndPoint { return .NewMessage }
    
    var path: String { return "/services/rest/message/send" }
    
    var method: HttpMethod { return .Post }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        // Check for success in response
        return nil
    }
}