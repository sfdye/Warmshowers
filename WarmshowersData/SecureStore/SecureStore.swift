//
//  SecureStore.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/06/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import KeychainAccess

public class SecureStore: SecureStoreDelegate {
    
    let keychain = Keychain(server: "www.warmshowers.org", protocolType: .https)
    
    struct PropertyKeys {
        static let TokenKey = "token"
        static let SecretKey = "secret"
        static let UsernameKey = "username"
        static let PasswordKey = "password"
        static let PINKey = "pin"
    }
    
    public init() {}
    
    // MARK: API Authorization
    
    public func setToken(_ token: String, andSecret secret: String) throws {
        try keychain.set(token, key: PropertyKeys.TokenKey)
        try keychain.set(secret, key: PropertyKeys.SecretKey)
    }
    
    public func getTokenAndSecret() throws -> (String, String) {
        let token = try keychain.get(PropertyKeys.TokenKey)
        guard token != nil else { throw SecureStoreError.noToken }
        let secret = try keychain.get(PropertyKeys.SecretKey)
        guard secret != nil else { throw SecureStoreError.noSecret }
        return (token!, secret!)
    }
    
    public func save(username: String, andPassword password: String) throws {
        try keychain.set(username, key: PropertyKeys.UsernameKey)
        try keychain.set(password, key: PropertyKeys.PasswordKey)
    }
    
    public func getUsernameAndPassword() throws -> (String, String) {
        let username = try keychain.get(PropertyKeys.UsernameKey)
        guard username != nil else { throw SecureStoreError.noUsername }
        let password = try keychain.get(PropertyKeys.PasswordKey)
        guard password != nil else { throw SecureStoreError.noPassword }
        return (username!, password!)
    }
    
    public func revokeAccess() throws {
        try keychain.remove(PropertyKeys.TokenKey)
        try keychain.remove(PropertyKeys.SecretKey)
        try keychain.remove(PropertyKeys.UsernameKey)
        try keychain.remove(PropertyKeys.PasswordKey)
    }
    
//    // MARK: Generic secure storage
//    
//    public func save(value: String, forKey key: String) throws {
//        try keychain.set(value, key: key)
//    }
//    
//    public func getValue(forKey key: String) throws -> String?  {
//        let value = try keychain.get(key)
//        return value
//    }
//    
//    public func removeValue(forKey key: String) throws {
//        try keychain.remove(key)
//    }
    
}
