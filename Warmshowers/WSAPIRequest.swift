//
//  WSAPIRequest.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

/**
 Defines a api request so that requests can be tracked by the HTTP client
 */
class WSAPIRequest : Hashable {
    
    var madeAt: NSDate
    var delegate: WSAPIRequestDelegate
    var endPoint: WSAPIEndPointProtocol
    
    var data: AnyObject?
    var token: String?
    var requester: WSAPIResponseDelegate?

    init(endPoint: WSAPIEndPoint, withDelegate delegate: WSAPIRequestDelegate, andRequester requester: WSAPIResponseDelegate?) {
        self.madeAt = NSDate()
        self.requester = requester
        self.delegate = delegate
        self.endPoint = WSAPIEndPointFactory.endPointWithEndPoint(endPoint)
    }
    
    // MARK: Hashable
    
    var hashValue: Int { return Int(self.madeAt.timeIntervalSince1970 * 1000) }
    
}

// MARK: Equatable

func ==(lhs: WSAPIRequest, rhs: WSAPIRequest) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
