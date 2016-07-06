//
//  WSMOCKSessionState.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
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

    func setUsername(_ username: String) {
        setUsernameCalled = true
    }
    
    func savePassword(_ password: String, forUsername username: String) throws {
        savePasswordForUsernameCalled = true
    }
    
    func saveSessionData(_ sessionCookie: String, token: String, uid: Int) {
        saveSessionDataCalled = true
    }
    
    func deleteSessionData() {
        deleteSessionDataCalled = true
    }
    
    func setToken(_ token: String) {
        setTokenCalled = true
    }
    
    var isLoggedIn: Bool {
        get {
            isLoggedInReturned = true
            return true
        }
    }

}
