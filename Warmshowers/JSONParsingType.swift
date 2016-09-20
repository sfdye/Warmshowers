//
//  JSONParsingType.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol JSONParsingType {
    associatedtype DataType
    
    /** Returns a value of it own type from the JSON dictionary for the given key, or nil if the value is nil, or casting to the desired type failed. */
    static func from(JSON json: Any, withKey key: String) -> DataType?
    
}
