//
//  WSUnreadMessageCount.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSUnreadMessageCountEndPoint: WSAPIEndPointProtocol {
    
    static let sharedEndPoint = WSUnreadMessageCountEndPoint()
    
    var type: WSAPIEndPoint { return .UnreadMessageCount }
    
    var path: String { return "/services/rest/message/unreadCount" }
    
    var method: HttpMethod { return .Post }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        return nil
    }
}