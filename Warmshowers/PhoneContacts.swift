//
//  PhoneContacts.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct PhoneContacts {
    
    var numbers = [PhoneNumber]()
    var count: Int { return numbers.count }
    
    mutating func update(userData: AnyObject?) {
        
        guard let userData = userData else {
            return
        }
        
        let keys = ["homephone", "mobilehone", "workphone"]
        
        for key in keys {
            let number = numberForKey(key, inData: userData)
            let type: PhoneNumberType
            switch key {
            case "homephone":
                type = .Home
            case "mobilephone":
                type = .Mobile
            case "workphone":
                type = .Work
            default:
                continue
            }
            
            if number != nil {
                self.numbers.append(PhoneNumber(number: number!, type: type))
            }
        }
    }
    
    func numberForKey(key: String, inData data: AnyObject) -> String? {
        
        let number = data.valueForKey(key) as? String
        if number == "" {
            return nil
        }
        return number
    }
    
}

