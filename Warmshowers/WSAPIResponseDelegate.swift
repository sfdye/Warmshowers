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
    func requestdidComplete(_ request: WSAPIRequest)
    
    /** Handles successful API request responses. */
    func request(_ request: WSAPIRequest, didSuceedWithData data: AnyObject?)
    
    /** Handles API request error responses. */
    func request(_ request: WSAPIRequest, didFailWithError error: ErrorProtocol)
}

extension WSAPIResponseDelegate {
    
    func requestdidComplete(_ request: WSAPIRequest) { }
    
}
