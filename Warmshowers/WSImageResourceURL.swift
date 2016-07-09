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
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        return NSURL(string: parameters as? String ?? "")!
    }
    
}