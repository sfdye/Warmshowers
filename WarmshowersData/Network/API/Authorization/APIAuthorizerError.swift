//
//  APIAuthorizerError.swift
//  Powershop
//
//  Created by Rajan Fernandez on 6/12/16.
//  Copyright © 2016 Powershop. All rights reserved.
//

import Foundation

public enum APIAuthorizerError: Error {
    case noDelegate
    case invalidHostURL
    case invalidAuthorizationData
    case currentlyReauthorizing
}
