//
//  LoginData.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class LoginData {
    
    var username: String
    var password: String
    
    var asParameters: [String: String] {
        var params = [String: String]()
        params["username"] = username
        params["password"] = password
        return params
    }
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
}
