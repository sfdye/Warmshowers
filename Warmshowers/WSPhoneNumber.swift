//
//  WSPhoneNumber.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 14/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSPhoneNumber {
    
    var type: WSPhoneNumberType
    var number: String
    
    init(type: WSPhoneNumberType, number: String) {
        self.type = type
        self.number = number
    }
    
}