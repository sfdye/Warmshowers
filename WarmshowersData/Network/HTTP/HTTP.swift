//
//  HTTP.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public struct HTTP {
    
    public enum Method: String {
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case trace = "TRACE"
        case options = "OPTIONS"
        case connect = "CONNECT"
        case patch = "PATCH"
    }
    
    public enum Scheme: String {
        case http = "http"
        case https = "https"
    }
    
}
