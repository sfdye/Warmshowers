//
//  SecureStore.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/06/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public class SecureStore: SecureStoreDelegate {
    
    let keychain = Keychain(server: "www.warmshowers.org", protocolType: .https)
    
    struct PropertyKeys {
        static let TokenKey = "token"
        static let SecretKey = "secret"
        static let PINKey = "pin"
    }
    
    public init() {}
    
    public func setToken(_ token: String, andSecret secret: String) throws {
        do {
            try keychain.set(token, key: PropertyKeys.TokenKey)
            try keychain.set(secret, key: PropertyKeys.SecretKey)
        }
    }
    
    public func getTokenAndSecret() throws -> (String, String) {
        do {
            let token = try keychain.get(PropertyKeys.TokenKey)
            guard token != nil else { throw SecureStoreError.noToken }
            let secret = try keychain.get(PropertyKeys.SecretKey)
            guard secret != nil else { throw SecureStoreError.noSecret }
            return (token!, secret!)
        }
    }
    
    public func revokeAccess() throws {
        do {
            try keychain.remove(PropertyKeys.TokenKey)
            try keychain.remove(PropertyKeys.SecretKey)
        }
    }
    
}
