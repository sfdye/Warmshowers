//
//  APIAuthorizationDelegate.swift
//  Powershop
//
//  Created by Rajan Fernandez on 14/07/16.
//  Copyright © 2016 Powershop. All rights reserved.
//

import Foundation

public protocol APIAuthorizationDelegate {
    
    var isCurrentlyAuthorizing: Bool { get }
    
    func canAuthorize(_ request: APIRequest) -> Bool
    
    /** Generates an authorized URL request given an API request and access to the secure store. */
    func authorizedURLRequest(fromAPIRequest request: APIRequest, withSecureStore secureStore: SecureStoreDelegate) throws -> URLRequest

}
