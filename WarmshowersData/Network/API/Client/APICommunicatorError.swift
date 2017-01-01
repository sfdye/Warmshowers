//
//  APICommunicatorError.swift
//  Powershop
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public enum APICommunicatorError: Error {
    case unknown
    case offline
    case noDelegate
    case failedToAuthenticateRequest
    case invalidHostURL
    case invalidEndPointURL
    case invalidImageResourceURL
    case serverError(statusCode: Int, body: String?)
    case noData
}
