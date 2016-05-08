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
    
    var endPoint: WSAPIEndPointProtocol
    var delegate: WSAPIRequestDelegate
    var requester: WSAPIResponseDelegate?
    var params: [String: String]?
    var status: WSAPIRequestStatus = .Created
    
    // MARK: Hashable
    
    var madeAt: NSDate
    var hashValue: Int { return Int(self.madeAt.timeIntervalSince1970 * 1000) }
    
    
    // MARK: Initialiser
    
    init(endPoint: WSAPIEndPoint, withDelegate delegate: WSAPIRequestDelegate, andRequester requester: WSAPIResponseDelegate?, andParameters params: [String : String]? = nil) {
        self.madeAt = NSDate()
        self.requester = requester
        self.delegate = delegate
        self.endPoint = endPoint.sharedEndPoint
    }
}

// MARK: Equatable

func ==(lhs: WSAPIRequest, rhs: WSAPIRequest) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
