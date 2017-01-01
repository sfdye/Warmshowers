//
//  APILoginResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

public protocol APILoginResponseDelegate: class {
    
    /** Handles successful API request responses. */
    func loginRequestDidSucceed(_ loginRequest: APILoginRequest)
    
    /** Handles API request error responses. */
    func loginRequest(_ loginRequest: APILoginRequest, didFailWithError error: Error)
    
}
