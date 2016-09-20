//
//  WSAPIHost.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

/** The API host details. The default host is NZ Live.*/
class WSAPIHost {
    
    static var sharedAPIHost = WSAPIHost()
    
    /** Returns the API host URL. */
    func hostURLWithHTTPScheme(_ httpScheme: HttpScheme = .HTTP) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = httpScheme.rawValue
        urlComponents.host = "www.warmshowers.org"
        return urlComponents.url
    }
    
}
