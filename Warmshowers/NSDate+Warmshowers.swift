//
//  NSDate+Warmshowers.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension NSDate: JSONParsingType {
    
    typealias DataType = NSDate
    static func fromJSON(json: AnyObject, withKey key: String) -> NSDate? {
        guard
            let dateString = json[key] as? String,
            let timeInterval = Double(dateString)
            else { return nil }
        return NSDate(timeIntervalSince1970: timeInterval)
    }
    
}