//
//  JSON.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct JSON {
    
    /** Returns an optional value of a specified type from a JSON dictionary given a dictionary key. */
    static func optionalForKey<T where T: JSONParsingType>(key: String, fromDict dict: AnyObject, withType type: T.Type) -> T.DataType? {
        let value = type.fromJSON(dict, withKey: key)
        return value
    }
    
    /** Returns an non-optional value of a specified type from a JSON dictionary given a dictionary key. This function will throw if it can find a non-null value for the key in the dictionary. */
    static func nonOptionalForKey<T where T: JSONParsingType>(key: String, fromDict dict: AnyObject, withType type: T.Type) throws -> T.DataType! {
        let value = type.fromJSON(dict, withKey: key)
        if value == nil { throw JSONParsingError.NilForNonOptional(key: key) }
        return value!
    }
    
}