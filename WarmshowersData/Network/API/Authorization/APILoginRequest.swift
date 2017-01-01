//
//  LoginRequest.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

public class APILoginRequest {
    
    public var username: String
    public var password: String
    var requester: APILoginResponseDelegate
    public var uid: Int = 0
    
    init(username: String, password: String, requester: APILoginResponseDelegate) {
        self.username = username
        self.password = password
        self.requester = requester
    }
    
    var loginCredentialsAsParameters: [String: String] {
        var params = [String: String]()
        params["username"] = username
        params["password"] = password
        return params
    }
    
}
