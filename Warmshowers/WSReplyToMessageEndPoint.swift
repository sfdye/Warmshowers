//
//  WSReplyToMessageEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSReplyToMessageEndPoint: WSAPIEndPointProtocol {
    
    static let sharedEndPoint = WSReplyToMessageEndPoint()
    
    var type: WSAPIEndPoint { return .ReplyToMessage }
    
    var path: String { return "/services/rest/message/reply" }
    
    var method: HttpMethod { return .Post }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        // Check for success in response
        return nil
    }
}