//
//  HostInfo.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 14/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public class HostInfo {
    
    public var type: HostInfoType
    public var description: String
    
    init(type: HostInfoType, description: String) {
        self.type = type
        self.description = description
    }
    
}
