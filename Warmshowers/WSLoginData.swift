//
//  WSLoginData.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSLoginData {
    
    var username: String
    var password: String
    
    var asQueryString: String {
        var params = [String: String]()
        params["username"] = username
        params["password"] = password
        return HttpBody.bodyStringWithParameters(params)
    }
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
}