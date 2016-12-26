//
//  UnreadMessageCount.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class UnreadMessageCountEndPoint: APIEndPointProtocol {
    
    var type: APIEndPoint = .unreadMessageCount
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/message/unreadCount")
    }
    
     func request(_ request: APIRequest, didRecieveResponseWithJSON json: Any, parser: JSONParser) throws -> Any? {
        return nil
    }
    
}
