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
    static func from(JSON json: Any, withKey key: String) -> Int? {
        if let json = json as? [String: Any], json[key] is Int { return json[key] as? Int}
        guard let valueString = String.from(JSON: json, withKey: key) else { return nil }
        return Int(valueString)
    }
    
}
