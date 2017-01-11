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
    
    var isFirstLaunch: Bool {
        // On first lauch, there is no last used username stored in the defaults.
        guard let _ = defaults.string(forKey: UserDefaultsKeys.usernameKey) else { return true }
        return false
    }
    
    var uid: Int? {
        return defaults.integer(forKey: UserDefaultsKeys.uidKey)
    }
    
    func save(uid: Int) {
        defaults.setValue(uid, forKey: UserDefaultsKeys.uidKey)
        defaults.synchronize()
    }
    
    var username: String? {
        return defaults.string(forKey: UserDefaultsKeys.usernameKey)
    }
    
    func set(username: String) {
        defaults.setValue(username, forKey: UserDefaultsKeys.usernameKey)
        defaults.synchronize()
    }
    
    func deleteSessionData() throws {
        
        // Remove the users password from the keychain.
        try secureStore.revokeAccess()
        
        // Delete the current users UID.
        defaults.removeObject(forKey: UserDefaultsKeys.uidKey)
        defaults.synchronize()
    }
    
    var isLoggedIn: Bool {
        do {
            let (token, secret) = try secureStore.getTokenAndSecret()
            return true && !isFirstLaunch
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
