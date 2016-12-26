//
//  APIRequestDelegate.swift
//  Powershop
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

/** This protocol defines a group of methods that may be used to process an api request at various stages through its life cycle. */
protocol APIRequestDelegate {
    
    /** Specifies if the http client should queue a request while offline for processing later once online again */
    func requestShouldBeQueuedWhileOffline(_ request: APIRequest) -> Bool
    
    /** Return the approriate host URL for the given request. */
    func hostURLForRequest(_ request: APIRequest) throws -> URL
    
    /** Called when an API request completes successfully */
    func request(_ request: APIRequest, didSucceedWithData data: Any?)
    
    /** Called when an API request fails with an error */
    func request(_ request: APIRequest, didFailWithError: Error)
    
}

extension APIRequestDelegate {
    
    func requestShouldBeQueuedWhileOffline(_ request: APIRequest) -> Bool {
        return false
    }
    
}
