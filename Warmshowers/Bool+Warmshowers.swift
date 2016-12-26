//
//  Bool+Warmshowers.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension Bool: JSONParsable {
    
    typealias DataType = Bool
    static func from(JSON json: Any, withKey key: String) -> Bool? {
        if let json = json as? [String: Any], json[key] is Bool { return json[key] as? Bool}
        guard let valueString = String.from(JSON: json, withKey: key) else { return nil }
        return (valueString as NSString).boolValue
    }
    
}
