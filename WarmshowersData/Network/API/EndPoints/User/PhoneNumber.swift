//
//  PhoneNumber.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 14/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public class PhoneNumber {
    
    public var type: PhoneNumberType
    public var number: String
    
    init(type: PhoneNumberType, number: String) {
        self.type = type
        self.number = number
    }
    
}
