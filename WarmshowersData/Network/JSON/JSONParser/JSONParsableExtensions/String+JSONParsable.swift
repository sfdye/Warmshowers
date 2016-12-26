//
//  String+JSONParsable.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/07/16.
//  Copyright © 2016 Warmshowers. All rights reserved.
//

import Foundation

extension String: JSONParsable {
    
    typealias DataType = String
    static func from(JSON json: Any, withKey key: String) -> String? {
        guard let json = json as? [String: Any] else { return nil }
        guard let value = json[key] else { return nil }
        return String(describing: value)
    }
    
}
