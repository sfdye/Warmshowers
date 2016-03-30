//
//  WSLoginData.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import KeychainAccess

// WSLoginData is a wrapper for saving and retrieving the users credentials
// - The user's username, uid and session cookie are stored in NSUserDefaults
// - The user's password is stored securely in the keychain

enum WSLoginDataError : ErrorType {
    case UsernameNotSet
    case PasswordNotSet
    case SessionCookieNotSet
    case UserUIDNotSet
}

class WSLoginData {
    
    static let defaults = (UIApplication.sharedApplication().delegate as! AppDelegate).defaults
    static let keychain = Keychain(server: WSURL.BASE, protocolType: .HTTPS)
    
    // Mark: Convenience properties
    
    static var username: String? {
        do {
            let username = try getUserName()
            return username
        } catch {
            return nil
        }
    }
    
    static var uid: Int { return getCurrentUserUID() }
    
    
    // MARK: Username
    
    // Save a username to NSUserDefaults
    static func saveUsername(username: String) {
        defaults.setValue(username, forKey: WSUserDefaultsKeys.UsernameKey)
        defaults.synchronize()
    }
    
    // Returns latest users username or nil
    //
    static func getUserName() throws -> String {
        if let username = defaults.stringForKey(WSUserDefaultsKeys.UsernameKey) {
            return username
        } else {
            throw WSLoginDataError.UsernameNotSet
        }
    }
    
    
    // MARK: Password
    
    // Retrieves the users password from the keychain
    //
    static func getPassword() throws -> String {
        do {
            let username = try getUserName()
            if let password = try keychain.get(username) {
                return password;
            } else {
                throw WSLoginDataError.PasswordNotSet
            }
        }
    }
    
    // Removes the users password from the keychain
    //
    static func deletePassword() throws {
        do {
            let username = try getUserName()
            try keychain.remove(username)
        }
    }
    
    
    // MARK: Full Credentials
    
    // Saves the users password to the keychain
    //
    static func saveCredentials(password: String, forUsername username: String) throws {
        do {
            try keychain.set(password, key: username)
            saveUsername(username)
        }
    }
    
    static func getCredentials() throws -> (username: String, password: String) {
        do {
            let password = try getPassword()
            let username = try getUserName()
            return (username, password)
        }
    }
    
    
    // MARK: Session Data
    
    // Saves a session cookie and the current users uid to NSUserDefaults
    //
    static func saveSessionData(sessionCookie: String, uid: Int) {
        defaults.setValue(sessionCookie, forKey: WSUserDefaultsKeys.SessionCookieKey)
        defaults.setValue(uid, forKey: WSUserDefaultsKeys.UserUIDKey)
        defaults.synchronize()
    }

    // Returns the current session cookie
    //
    static func getSessionCookie() throws -> String {
        if let sessionCookie = defaults.stringForKey(WSUserDefaultsKeys.SessionCookieKey) {
            return sessionCookie
        } else {
            throw WSLoginDataError.SessionCookieNotSet
        }
    }
    
    static func deleteSessionCookie() {
        defaults.removeObjectForKey(WSUserDefaultsKeys.SessionCookieKey)
    }
    
    // Returns the current users uid
    static func getCurrentUserUID() -> Int {
        return defaults.integerForKey(WSUserDefaultsKeys.UserUIDKey)
    }
    
    static func deleteCurrentUserUID() {
        defaults.removeObjectForKey(WSUserDefaultsKeys.UserUIDKey)
    }
    
    
    // MARK: Removal methods
    
    // Clears all login data
    //
    static func removeDataForLogout() throws {
        // Remove all except for the username so that it can be set in the login view
        do {
            deleteCurrentUserUID()
            deleteSessionCookie()
            try deletePassword()
        }
    }
}
