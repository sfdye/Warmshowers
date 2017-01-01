//
//  APILoginDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

public protocol APILoginDelegate {
    
    func login(withUsername username: String, andPassword password: String, thenNotify requester: APILoginResponseDelegate)
    
}
