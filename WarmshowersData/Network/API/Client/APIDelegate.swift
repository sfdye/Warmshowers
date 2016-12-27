//
//  APICommunicatorProtocol.swift
//  Powershop
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public protocol APIDelegate {
    
    var connection: ReachabilityDelegate { get }
    
    /** Creates and executes a request for the given end point with the given data. */
    func contact(endPoint: APIEndPoint, withMethod method: HTTP.Method, andPathParameters parameters: Any?, andData data: Any?, thenNotify requester: APIResponseDelegate)
    
}
