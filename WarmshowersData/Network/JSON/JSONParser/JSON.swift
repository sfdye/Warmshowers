//
//  JSON.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 23/12/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct JSON: JSONParser {
    
    static let shared = JSON()
    
    /** Returns an optional value of a specified type from a JSON dictionary given a dictionary key. */
    func optional<T>(forKey key: String, fromJSON json: Any, withType type: T.Type) -> T.DataType? where T: JSONParsable {
        let value = type.from(JSON: json, withKey: key)
        return value
    }
    
    /** Returns an non-optional value of a specified type from a JSON dictionary given a dictionary key. This function will throw if it can find a non-null value for the key in the dictionary. */
    func nonOptional<T>(forKey key: String, fromJSON json: Any, withType type: T.Type) throws -> T.DataType where T: JSONParsable {
        let value = type.from(JSON: json, withKey: key)
        if value == nil { throw JSONParsingError.nilForNonOptional(key: key) }
        return value! as T.DataType
    }
    
}
