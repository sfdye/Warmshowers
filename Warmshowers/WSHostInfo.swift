//
//  WSHostInfo.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 14/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSHostInfo {
    
    var type: WSHostInfoType
    var description: String
    
    init(type: WSHostInfoType, description: String) {
        self.type = type
        self.description = description
    }
    
}