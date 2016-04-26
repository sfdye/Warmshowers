//
//  WSAPIRequestDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSAPIRequestDelegate {
    
    /** Defines how responses from the API should be handled */
    func request(request: WSAPIRequest, didRecieveHTTPResponse data: NSData?, response: NSURLResponse?, andError error: NSError?)
    
    /** Called when an API request completes successfully */
    func request(request: WSAPIRequest, didSucceedWithData data: AnyObject?)
    
    /** Called when an API request fails with an error */
    func request(request: WSAPIRequest, didFailWithError: ErrorType)
}