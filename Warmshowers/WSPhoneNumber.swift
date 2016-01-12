//
//  WSPhoneNumber.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct WSPhoneNumber {
    
    var number: String
    var type: WSPhoneNumberType
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
    
    init(number: String, type: WSPhoneNumberType) {
        self.number = number
        self.type = type
    }
}