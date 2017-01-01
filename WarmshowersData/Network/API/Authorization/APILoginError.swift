//
//  APILoginError.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

public enum APILoginError: Error {
    case loginAlreadyInProgress
    case invalidCredentials
    case invalidUIDRecieved
    case invalidAPIRequest
}
