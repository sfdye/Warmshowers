//
//  JSONParsable.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/07/16.
//  Copyright © 2016 Warmshowers. All rights reserved.
//

import Foundation

protocol JSONParsable {
    associatedtype DataType
    
    /** Returns a value of it own type from the JSON dictionary for the given key, or nil if the value is nil, or casting to the desired type failed. */
    static func from(JSON json: Any, withKey key: String) -> DataType?
    
}
