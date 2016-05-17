//
//  WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSAPIResponseDelegate {
    
    /** Handles successful API request responses. */
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?)
    
    /** Handles API request error responses. */
    func request(request: WSAPIRequest, didFailWithError error: ErrorType)
}