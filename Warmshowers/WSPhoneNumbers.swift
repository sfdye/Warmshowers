//
//  WSPhoneContacts.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

struct WSPhoneNumbers {
    
    var numbers = [WSPhoneNumber]()
    var count: Int { return numbers.count }
    
    var numberOfPhoneNumbers: Int {
        return numbers.count
    }
    
    mutating func update(json: AnyObject?) {
        
        guard let json = json else { return }
        
        let keys = ["homephone", "mobilephone", "workphone"]
        
        for key in keys {
            let number = numberForKey(key, inJSON: json)
            let type: WSPhoneNumberType
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
                self.numbers.append(WSPhoneNumber(number: number!, type: type))
            }
        }
    }
    
    private func numberForKey(key: String, inJSON json: AnyObject) -> String? {
        guard let number = json[key] as? String where number != "" else { return nil }
        return number
    }
    
}

