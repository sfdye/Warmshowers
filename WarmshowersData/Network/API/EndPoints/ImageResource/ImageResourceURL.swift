//
//  ResourceURL.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class ImageResourceEndPoint: APIEndPointProtocol {
    
    var type: APIEndPoint = .imageResource
    
    var acceptType: ContentType = .image
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        
        switch parameters {
        
        case is String:
            
            guard let url = URL(string: parameters as! String) else {
                throw APIEndPointError.invalidPathParameters(endPoint: name, errorDescription: "Invlaid URL for image resource")
            }
            
            return url

        default:
            throw APIEndPointError.invalidPathParameters(endPoint: name, errorDescription: "The image resource endpoint must receieve the image URL in the path parameters.")
        }
    }
    
}
