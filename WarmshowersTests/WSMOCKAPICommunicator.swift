//
//  WSMOCKAPICommunicator.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
@testable import Warmshowers

class WSMOCKAPICommunicator : WSAPICommunicatorProtocol {
    
    var contactEndPointCalled = false
    var contactedEndPoint: WSAPIEndPoint?
    
    func contact(endPoint: WSAPIEndPoint, withPathParameters parameters: Any?, andData data: Any?, thenNotify requester: WSAPIResponseDelegate) {
        contactEndPointCalled = true
        contactedEndPoint = endPoint
    }
    
}
