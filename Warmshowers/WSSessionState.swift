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
    
    let defaults = UserDefaults.standard()
    let keychain = Keychain(server: WSURL.BASE, protocolType: .HTTPS)
    
    var uid: Int? { return defaults.integer(forKey: WSUserDefaultsKeys.UIDKey) }
    var username: String? { return defaults.string(forKey: WSUserDefaultsKeys.UsernameKey) }
    
    func setUsername(_ username: String) {
        defaults.setValue(username, forKey: WSUserDefaultsKeys.UsernameKey)
        defaults.synchronize()
    }
    
    /** 
     Saves a users username and password. The password is saved securely in the users keychain, while the username is store in the the NSUserDefaults.
     */
    func savePassword(_ password: String, forUsername username: String) throws {
        do {
            try keychain.set(password, key: username)
            setUsername(username)
        }
    }
    
    func saveSessionData(_ sessionCookie: String, token: String, uid: Int) {
        defaults.setValue(sessionCookie, forKey: WSUserDefaultsKeys.SessionCookieKey)
        defaults.setValue(token, forKey: WSUserDefaultsKeys.TokenKey)
        defaults.setValue(uid, forKey: WSUserDefaultsKeys.UIDKey)
        defaults.synchronize()
    }
    
    func getSessionData() -> (sessionCookie: String?, token: String?, uid: Int?) {
        let sessionCookie = defaults.string(forKey: WSUserDefaultsKeys.SessionCookieKey)
        let token = defaults.string(forKey: WSUserDefaultsKeys.TokenKey)
        let uid = defaults.integer(forKey: WSUserDefaultsKeys.UIDKey)
        return (sessionCookie, token, uid)
    }
    
    func deleteSessionData() {
        defaults.removeObject(forKey: WSUserDefaultsKeys.SessionCookieKey)
        defaults.removeObject(forKey: WSUserDefaultsKeys.TokenKey)
        defaults.removeObject(forKey: WSUserDefaultsKeys.UIDKey)
        defaults.synchronize()
    }
    
    func setToken(_ token: String) {
        defaults.setValue(token, forKey: WSUserDefaultsKeys.TokenKey)
        defaults.synchronize()
    }
    
    var isLoggedIn: Bool {
        return defaults.object(forKey: WSUserDefaultsKeys.SessionCookieKey) != nil
    }
}
