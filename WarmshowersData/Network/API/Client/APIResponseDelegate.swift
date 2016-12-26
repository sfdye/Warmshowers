//
//  APIResponseDelegate.swift
//  Powershop
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public protocol APIResponseDelegate {
    
    /** Is called immediately after an API request completes and before request:didSucceedWithData: or request:didFailWithData is called. */
    func requestDidComplete(_ request: APIRequest)
    
    /** Handles successful API request responses. */
    func request(_ request: APIRequest, didSucceedWithData data: Any?)
    
    /** Handles API request error responses. */
    func request(_ request: APIRequest, didFailWithError error: Error)
    
}

public extension APIResponseDelegate {
    
    func requestDidComplete(_ request: APIRequest) { }
    
}
