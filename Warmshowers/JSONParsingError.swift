//
//  JSONParsingError.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum JSONParsingError: ErrorType {
    case NilForNonOptional(key: String)
}