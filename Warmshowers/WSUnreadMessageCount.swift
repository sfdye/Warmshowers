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
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/message/unreadCount")
    }
    
    func request(_ request: WSAPIRequest, didRecieveResponseWithJSON json: Any) throws -> Any? {
        return nil
    }
    
}
