//
//  String+Warmshowers.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension String: JSONParsingType {
    
    typealias DataType = String
    static func from(JSON json: Any, withKey key: String) -> String? {
        guard let json = json as? [String: Any] else { return nil }
        return json[key] as? String
    }
    
}
