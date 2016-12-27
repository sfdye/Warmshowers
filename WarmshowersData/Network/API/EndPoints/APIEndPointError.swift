//
//  APIEndPointError.swift
//  Powershop
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public enum APIEndPointError : Error {
    case unsupportedMethod(endPoint: String, method: HTTP.Method)
    case invalidPathParameters(endPoint: String, errorDescription: String?)
    case invalidOutboundData(endPoint: String, errorDescription: String?)
    case parsingError(endPoint: String, key: String?)
    case storeError(description: String)
    case reachedTileLimit
}
