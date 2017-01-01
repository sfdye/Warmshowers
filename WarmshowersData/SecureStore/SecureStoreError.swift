//
//  SecureStoreError.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum SecureStoreError: Error {
    case noToken
    case noSecret
    case noUsername
    case noPassword
}
