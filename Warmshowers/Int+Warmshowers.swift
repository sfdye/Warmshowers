//
//  Int+Warmshowers.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension Int: JSONParsingType {
    
    typealias DataType = Int
    static func fromJSON(json: AnyObject, withKey key: String) -> Int? {
        if json[key] is Int { return json[key] as? Int }
        guard let valueString = String.fromJSON(json, withKey: key) else { return nil }
        return Int(valueString)
    }
    
}