//
//  WSAPIRequestDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSAPIRequestDelegate {
    
    /** Specifies if the http client should queue a request while offline for processing later once online again */
    func requestShouldBeQueuedWhileOffline(request: WSAPIRequest) -> Bool
    
    /** Returns the host that the end point should use. */
    func hostForRequest(request: WSAPIRequest) -> WSAPIHost
    
    /** Called when an API request completes successfully */
    func request(request: WSAPIRequest, didSucceedWithData data: AnyObject?)
    
    /** Called when an API request fails with an error */
    func request(request: WSAPIRequest, didFailWithError: ErrorType)
}