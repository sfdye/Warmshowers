//
//  WSMOUpdateError.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSMOUpdateError: Error {
    case parsingError(className: String, key: String?)
    case castingError
    case invalidPropertyStatus
    case invalidDependency
    case jsonPredicateError(className: String, key: String?)
}
