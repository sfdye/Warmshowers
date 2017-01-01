//
//  APICommunicatorDelegate.swift
//  Pods
//
//  Created by Rajan Fernandez on 29/08/16.
//
//

import Foundation

public protocol APICommunicatorDelegate {
    
    /** Returns the test environment name. When nil is returned the communicator uses the live server. */
    func subDomainForRequest(_ request: APIRequest) -> String
    
    /** Returns the host URL for API Requests. */
    func hostDomainForRequest(_ request: APIRequest) -> String
    
    /** Specifies if the http client should queue a request while offline for processing later once online again */
    func requestShouldBeQueuedWhileOffline(_ request: APIRequest) -> Bool
    
}

extension APICommunicatorDelegate {

    func requestShouldBeQueuedWhileOffline(_ request: APIRequest) -> Bool {
        return false
    }
    
}
