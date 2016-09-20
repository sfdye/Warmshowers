//
//  Double+Warmshowers.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension Double: JSONParsingType {
    
    typealias DataType = Double
    static func from(JSON json: Any, withKey key: String) -> Double? {
        if let json = json as? [String: Any], json[key] is Double { return json[key] as? Double }
        guard let valueString = String.from(JSON: json, withKey: key) else { return nil }
        return Double(valueString)
    }
    
}
