//
//  NSDate+JSONParsable.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/07/16.
//  Copyright © 2016 Warmshowers. All rights reserved.
//

import Foundation

extension Date: JSONParsable {
    
    typealias DataType = Date
    static func from(JSON json: Any, withKey key: String) -> Date? {
        guard
            let dateString = String.from(JSON: json, withKey: key),
            let timeInterval = Double(dateString)
            else { return nil }
        return Date(timeIntervalSince1970: timeInterval)
    }
    
}
