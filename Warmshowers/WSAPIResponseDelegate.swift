//
//  WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSAPIResponseDelegate {
    
    /** Is called when a request is completed before either .didSucceedWithData or .didFailWithData is called. */
    func requestDidComplete(request: WSAPIRequest)
    
    /** Handles successful API request responses. */
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?)
    
    /** Handles API request error responses. */
    func request(request: WSAPIRequest, didFailWithError error: ErrorType)
}

extension WSAPIResponseDelegate {
    
    func requestDidComplete(request: WSAPIRequest) { }
    
}