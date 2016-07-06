//
//  WSCreateFeedbackEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSCreateFeedbackEndPoint : WSAPIEndPointProtocol {
    
    static let sharedEndPoint = WSCreateFeedbackEndPoint()
    
    var type: WSAPIEndPoint { return .createFeedback }
    
    var path: String { return "/services/rest/node" }
    
    var method: HttpMethod { return .Post }
    
    func request(_ request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        // No need for response data.
        return nil
    }
    
    func generateMockResponseForURLRequest(_ urlRequest: NSMutableURLRequest) -> (Data?, URLResponse?, NSError?) {
        let data = Data()
        let response = URLResponse()
        return (data, response, nil)
    }
}
