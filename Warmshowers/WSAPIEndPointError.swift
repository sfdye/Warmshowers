//
//  WSAPIEndPointError.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSAPIEndPointError : ErrorType {
    case ParsingError(endPoint: String, key: String?)
}