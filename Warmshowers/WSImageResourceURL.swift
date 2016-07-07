//
//  WSResourceURL.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSImageResourceURL: WSAPIEndPointProtocol {
    
    var url: String
    
    init(url: String) {
        self.url = url
    }
    
    var type: WSAPIEndPoint { return .ImageResource }
    
    var path: String { return url ?? "" }
    
    var method: HttpMethod { return .Get }
}