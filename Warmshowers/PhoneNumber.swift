//
//  PhoneNumber.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum PhoneNumberType: Int {
    case Home
    case Mobile
    case Work
}

struct PhoneNumber {
    
    var number: String
    var type: PhoneNumberType
    var description: String {
        switch type {
        case .Home:
            return "Home Number"
        case .Mobile:
            return "Mobile Number"
        case .Work:
            return "Work Number"
        }
    }
    
    init(number: String, type: PhoneNumberType) {
        self.number = number
        self.type = type
    }
}