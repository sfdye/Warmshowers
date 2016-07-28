//
//  Bool+Warmshowers.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension Bool: JSONParsingType {
    
    typealias DataType = Bool
    static func fromJSON(json: AnyObject, withKey key: String) -> Bool? {
        if json[key] is Bool { return json[key] as? Bool }
        guard let valueString = String.fromJSON(json, withKey: key) else { return nil }
        return (valueString as NSString).boolValue
    }
    
}