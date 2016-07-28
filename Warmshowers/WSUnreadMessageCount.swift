//
//  WSUnreadMessageCount.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSUnreadMessageCountEndPoint: WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .UnreadMessageCount
    
    var httpMethod: HttpMethod = .Post
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        return hostURL.URLByAppendingPathComponent("/services/rest/message/unreadCount")
    }
    
    func request(request: WSAPIRequest, didRecieveResponseWithJSON json: AnyObject) throws -> AnyObject? {
        return nil
    }
    
}