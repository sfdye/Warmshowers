//
//  MOCKAPICommunicator.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
@testable import Warmshowers
@testable import WarmshowersData

class MOCKAPICommunicator: APIDelegate {
    
    var connection: ReachabilityDelegate {
        return ReachabilityManager()
    }
    
    var contactEndPointCalled = false
    var contactedEndPoint: APIEndPoint?
    
    func contact(endPoint: APIEndPoint, withMethod method: HTTP.Method, andPathParameters parameters: Any?, andData data: Any?, thenNotify requester: APIResponseDelegate) {
        contactEndPointCalled = true
        contactedEndPoint = endPoint
    }
    
}
