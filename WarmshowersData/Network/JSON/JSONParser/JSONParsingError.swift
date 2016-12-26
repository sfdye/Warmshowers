//
//  JSONError.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/07/16.
//  Copyright © 2016 Warmshowers. All rights reserved.
//

import Foundation

enum JSONParsingError: Error {
    case nilForNonOptional(key: String)
    case failedToInitialiseInstanceFromJSON(instanceType: String)
}
