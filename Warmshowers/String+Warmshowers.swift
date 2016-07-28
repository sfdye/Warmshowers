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
    static func fromJSON(json: AnyObject, withKey key: String) -> String? {
        return json[key] as? String
    }
    
}