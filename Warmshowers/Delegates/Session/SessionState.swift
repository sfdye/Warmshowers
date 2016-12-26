//
//  SessionState.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import KeychainAccess

class SessionState: SessionStateProtocol {
    
    static let sharedSessionState = SessionState()
    
    let defaults = UserDefaults.standard
    let keychain = Keychain(server: APIHost.sharedAPIHost.hostURLWithHTTPScheme()!, protocolType: .https)
    
    var uid: Int? { return defaults.integer(forKey: UserDefaultsKeys.UIDKey) }
    var username: String? { return defaults.string(forKey: UserDefaultsKeys.UsernameKey) }
    
    // Delegates
    var navigation: NavigationProtocol = NavigationDelegate.sharedNavigationDelegate
    var store: StoreProtocol = Store.sharedStore
    var alert: AlertProtocol = AlertDelegate.sharedAlertDelegate
    
    
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
    
    func save(sessionCookie: String, token: String, andUID uid: Int) {
        defaults.setValue(sessionCookie, forKey: UserDefaultsKeys.SessionCookieKey)
        defaults.setValue(token, forKey: UserDefaultsKeys.TokenKey)
        defaults.setValue(uid, forKey: UserDefaultsKeys.UIDKey)
        defaults.synchronize()
    }
    
    func getSessionData() -> (sessionCookie: String?, token: String?, uid: Int?) {
        let sessionCookie = defaults.string(forKey: UserDefaultsKeys.SessionCookieKey)
        let token = defaults.string(forKey: UserDefaultsKeys.TokenKey)
        let uid = defaults.integer(forKey: UserDefaultsKeys.UIDKey)
        return (sessionCookie, token, uid)
    }
    
    func deleteSessionData() {
        defaults.removeObject(forKey: UserDefaultsKeys.SessionCookieKey)
        defaults.removeObject(forKey: UserDefaultsKeys.TokenKey)
        defaults.removeObject(forKey: UserDefaultsKeys.UIDKey)
        defaults.synchronize()
    }
    
    func set(token: String) {
        defaults.setValue(token, forKey: UserDefaultsKeys.TokenKey)
        defaults.synchronize()
    }
    
    var isLoggedIn: Bool {
        return defaults.object(forKey: UserDefaultsKeys.SessionCookieKey) != nil
    }
    
    func didLogout(fromViewContoller viewController: UIViewController?) {
        do {
            deleteSessionData()
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
