//
//  WSMOUpdateError.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSMOUpdateError: ErrorType {
    case ParsingError(className: String, key: String?)
    case CastingError
    case InvalidPropertyStatus
    case InvalidDependency
    case JSONPredicateError(className: String, key: String?)
}