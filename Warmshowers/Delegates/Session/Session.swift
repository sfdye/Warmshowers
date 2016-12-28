//
//  SessionState.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import WarmshowersData
import KeychainAccess

class Session: SessionDelegate, Delegator, DataSource {
    
    static let shared = Session()
    
    let defaults = UserDefaults.standard
    let keychain = Keychain(server: "www.warmshowers.org", protocolType: .https)
    
    var uid: Int? {
        return defaults.integer(forKey: UserDefaultsKeys.UIDKey)
    }
    
    func save(uid: Int) {
        defaults.setValue(uid, forKey: UserDefaultsKeys.UIDKey)
        defaults.synchronize()
    }
    
    var username: String? {
        return defaults.string(forKey: UserDefaultsKeys.UsernameKey)
    }
    
    func set(username: String) {
        defaults.setValue(username, forKey: UserDefaultsKeys.UsernameKey)
        defaults.synchronize()
    }
    
    /** 
     Saves a users username and password. The password is saved securely in the users keychain, while the username is store in the the NSUserDefaults.
     */
    func save(password: String, forUsername username: String) throws {
        do {
            try keychain.set(password, key: username)
            set(username: username)
        }
    }
    
    func deleteSessionData() throws {
        
        // Remove the users password from the keychain.
        if let username = username {
            try secureStore.removeValue(forKey: username)
        }
        
        // Delete the current users UID.
        defaults.removeObject(forKey: UserDefaultsKeys.UIDKey)
        defaults.synchronize()
    }
    
    var isLoggedIn: Bool {
        do {
            let (_, _) = try secureStore.getTokenAndSecret()
            return true
        } catch {
            return false
        }
    }
    
    func didLogout(fromViewContoller viewController: UIViewController?) {
        do {
            try deleteSessionData()
            try store.clearout()
            navigation.showLoginScreen()
        } catch {
            // Suggest that the user delete the app for privacy.
            guard let viewController = viewController else { return }
            alert.presentAlertFor(viewController, withTitle: "Data Error", button: "OK", message: "Sorry, an error occured while removing your account data from this iPhone. If you would like to remove your Warmshowers messages from this iPhone please try deleting the Warmshowers app.", andHandler: { [weak self] (action) in
                self?.navigation.showLoginScreen()
                })
        }
    }
    
}
