//
//  WSMarkMessageEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSMarkMessageEndPoint: WSAPIEndPointProtocol {
    
    static let sharedEndPoint = WSMarkMessageEndPoint()
    
    var type: WSAPIEndPoint { return .markMessage }
    
    var path: String { return "/services/rest/message/markThreadRead" }
    
    var method: HttpMethod { return .Post }
    
    func request(_ request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
        // Successful requests get a response with "1" in the body
        if json.count == 1 {
            if let success = json.object(0) as? Bool {
                return success
            }
        }
        return nil
    }
}
