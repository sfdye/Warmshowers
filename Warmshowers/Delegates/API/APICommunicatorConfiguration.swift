//
//  APICommunicatorConfiguration.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/12/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import WarmshowersData

class APICommunicatorConfiguration: APICommunicatorDelegate {
    
    func subDomainForRequest(_ request: APIRequest) -> String {
        return "www"
    }
    
    func hostDomainForRequest(_ request: APIRequest) -> String {
        return "warmshowers.org"
    }
    
}
