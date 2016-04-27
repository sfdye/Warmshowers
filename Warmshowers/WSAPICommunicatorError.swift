//
//  WSAPICommunicatorError.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSAPICommunicatorError : ErrorType {
    case Offline
    case NoSessionCookie
    case NoToken
    case ServerError(statusCode: Int)
    case NoData
}