//
//  WSResourceURL.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSImageResourceEndPoint: WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .ImageResource
    
    var httpMethod: HttpMethod = .Get
    
    var acceptType: AcceptType = .Image
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        
        guard let stringURL = parameters as? NSString where stringURL != "" else {
            throw WSAPIEndPointError.InvalidPathParameters
        }
        
        guard let url = NSURL(string: stringURL as String) else {
            throw WSAPIEndPointError.InvalidPathParameters
        }

        return url
    }
    
}