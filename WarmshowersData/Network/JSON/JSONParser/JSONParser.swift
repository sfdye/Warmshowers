//
//  JSONParser.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/07/16.
//  Copyright © 2016 Warmshowers. All rights reserved.
//

import Foundation

protocol JSONParser {
    
    func optional<T>(forKey key: String, fromJSON json: Any, withType type: T.Type) -> T.DataType? where T: JSONParsable
    
    func nonOptional<T>(forKey key: String, fromJSON json: Any, withType type: T.Type) throws -> T.DataType where T: JSONParsable
    
}
