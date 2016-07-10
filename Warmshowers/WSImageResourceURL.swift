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
        
        switch parameters {
        
        case is String:
            
            guard let url = NSURL(string: parameters as! String) else {
                throw WSAPIEndPointError.InvalidPathParameters
            }
            
            return url

        default:
            throw WSAPIEndPointError.InvalidPathParameters
        }
    }
    
}