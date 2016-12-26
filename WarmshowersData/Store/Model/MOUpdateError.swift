//
//  MOUpdateError.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/07/16.
//  Copyright © 2016 Warmshowers. All rights reserved.
//

import Foundation

enum MOUpdateError: Error {
    case parsingError(className: String, key: String?)
    case castingError
    case invalidPropertyStatus
    case invalidDependency
    case predicateError(className: String, key: String?)
}
