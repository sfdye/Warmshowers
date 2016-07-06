//
//  WSPhoneContacts.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

struct WSPhoneContacts {
    
    var numbers = [WSPhoneNumber]()
    var count: Int { return numbers.count }
    
    mutating func update(_ userData: AnyObject?) {
        
        guard let userData = userData else {
            return
        }
        
        let keys = ["homephone", "mobilephone", "workphone"]
        
        for key in keys {
            let number = numberForKey(key, inData: userData)
            let type: WSPhoneNumberType
            switch key {
            case "homephone":
                type = .home
            case "mobilephone":
                type = .mobile
            case "workphone":
                type = .work
            default:
                continue
            }
            
            if number != nil {
                self.numbers.append(WSPhoneNumber(number: number!, type: type))
            }
        }
    }
    
    func numberForKey(_ key: String, inData data: AnyObject) -> String? {
        
        let number = data.value(forKey: key) as? String
        if number == "" {
            return nil
        }
        return number
    }
    
}

