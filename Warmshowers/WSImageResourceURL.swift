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
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        
        switch parameters {
        
        case is String:
            
            guard let url = URL(string: parameters as! String) else {
                throw WSAPIEndPointError.invalidPathParameters
            }
            
            return url

        default:
            throw WSAPIEndPointError.invalidPathParameters
        }
    }
    
}
