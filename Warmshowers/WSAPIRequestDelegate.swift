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
    func requestShouldBeQueuedWhileOffline(_ request: WSAPIRequest) -> Bool
    
    /** Defines how responses from the API should be handled */
    func request(_ request: WSAPIRequest, didRecieveHTTPResponse data: Data?, response: URLResponse?, andError error: NSError?)
    
    /** Called when an API request completes successfully */
    func request(_ request: WSAPIRequest, didSucceedWithData data: AnyObject?)
    
    /** Called when an API request fails with an error */
    func request(_ request: WSAPIRequest, didFailWithError: ErrorProtocol)
}
