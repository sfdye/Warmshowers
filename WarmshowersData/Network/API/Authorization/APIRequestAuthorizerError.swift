//
//  APIRequestAuthorizerError.swift
//  Powershop
//
//  Created by Rajan Fernandez on 6/12/16.
//  Copyright © 2016 Powershop. All rights reserved.
//

import Foundation

public enum APIRequestAuthorizerError: Error {
    case noDelegate
    case invalidHostURL
    case invalidAuthorizationData
}
