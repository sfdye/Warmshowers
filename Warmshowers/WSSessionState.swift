//
//  WSSessionState.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import KeychainAccess

class WSSessionState : WSSessionStateProtocol {
    
    static let sharedSessionState = WSSessionState()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let keychain = Keychain(server: WSURL.BASE, protocolType: .HTTPS)
    
    var username: String? { return defaults.stringForKey(WSUserDefaultsKeys.UsernameKey) }
    
    func setUsername(username: String) {
        defaults.setValue(username, forKey: WSUserDefaultsKeys.UsernameKey)
        defaults.synchronize()
    }
    
    /** 
     Saves a users username and password. The password is saved securely in the users keychain, while the username is store in the the NSUserDefaults.
     */
    func savePassword(password: String, forUsername username: String) throws {
        do {
            try keychain.set(password, key: username)
            setUsername(username)
        }
    }
    
    func saveSessionData(sessionCookie: String, token: String, uid: Int) {
        defaults.setValue(sessionCookie, forKey: WSUserDefaultsKeys.SessionCookieKey)
        defaults.setValue(token, forKey: WSUserDefaultsKeys.TokenKey)
        defaults.setValue(uid, forKey: WSUserDefaultsKeys.UserUIDKey)
        defaults.synchronize()
    }
    
    func deleteSessionData(sessionCookie: String, token: String, uid: Int) {
        defaults.removeObjectForKey(WSUserDefaultsKeys.SessionCookieKey)
        defaults.removeObjectForKey(WSUserDefaultsKeys.TokenKey)
        defaults.removeObjectForKey(WSUserDefaultsKeys.UserUIDKey)
        defaults.synchronize()
    }
}