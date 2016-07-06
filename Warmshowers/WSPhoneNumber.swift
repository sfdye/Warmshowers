//
//  WSPhoneNumber.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

struct WSPhoneNumber {
    
    var number: String
    var type: WSPhoneNumberType
    var description: String {
        switch type {
        case .home:
            return "Home Number"
        case .mobile:
            return "Mobile Number"
        case .work:
            return "Work Number"
        }
    }
    
    init(number: String, type: WSPhoneNumberType) {
        self.number = number
        self.type = type
    }
}
