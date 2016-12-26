//
//  PhoneNumber.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 14/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class PhoneNumber {
    
    var type: PhoneNumberType
    var number: String
    
    init(type: PhoneNumberType, number: String) {
        self.type = type
        self.number = number
    }
    
}
