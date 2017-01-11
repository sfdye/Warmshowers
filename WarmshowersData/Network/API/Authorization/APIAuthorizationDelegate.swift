//
//  APIAuthorizationDelegate.swift
//  Powershop
//
//  Created by Rajan Fernandez on 14/07/16.
//  Copyright © 2016 Powershop. All rights reserved.
//

import Foundation

public protocol APIAuthorizationDelegate {
    
    var isAvailible: Bool { get }
    
    /** Generates an authorized URL request given an API request and access to the secure store. */
    func authorizedURLRequest(fromAPIRequest request: APIRequest, withSecureStore secureStore: SecureStoreDelegate) throws -> URLRequest

}
