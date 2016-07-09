//
//  HttpBody.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct HttpBody {
    
    /** Utility method to return a dictionary of parameters as a query string. */
    static func bodyStringWithParameters(parameters: [String: String]) -> String {
        
        var bodyString = ""
        let keys: [String] = Array(parameters.keys)
        
        for key in keys {
            if bodyString != "" { bodyString += "&" }
            bodyString += "\(key)=\(parameters[key]!)"
        }
        
        return bodyString
    }
    
}