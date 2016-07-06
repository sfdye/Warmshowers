//
//  WSAPICommunicatorError.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSAPICommunicatorError : ErrorProtocol {
    case offline
    case noSessionCookie
    case noToken
    case invalidImageResourceURL
    case serverError(statusCode: Int, body: String?)
    case noData
}
