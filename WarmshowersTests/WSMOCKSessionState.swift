//
//  WSMOCKSessionState.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
@testable import Warmshowers

class WSMOCKSessionState : WSSessionStateProtocol {
    
    var uidReturned = false
    var usernameReturned = false
    var setUsernameCalled = false
    var savePasswordForUsernameCalled = false
    var saveSessionDataCalled = false
    var deleteSessionDataCalled = false
    var setTokenCalled = false
    var isLoggedInReturned = false
    var didLogoutCalled = false
    
    var uid: Int? {
        get {
            uidReturned = true
            return 0
        }
    }
    
    var username: String? {
        get {
            usernameReturned = true
            return "username"
        }
    }

    func set(username: String) {
        setUsernameCalled = true
    }
    
    func save(password: String, forUsername username: String) throws {
        savePasswordForUsernameCalled = true
    }
    
    func save(sessionCookie: String, token: String, andUID uid: Int) {
        saveSessionDataCalled = true
    }
    
    func deleteSessionData() {
        deleteSessionDataCalled = true
    }
    
    func set(token: String) {
        setTokenCalled = true
    }
    
    var isLoggedIn: Bool {
        get {
            isLoggedInReturned = true
            return true
        }
    }
    
    func didLogout(fromViewContoller viewController: UIViewController?) {
        didLogoutCalled = true
    }

}
