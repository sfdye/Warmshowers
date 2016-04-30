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
    
    var usernameReturned = false
    var setUsernameCalled = false
    var savePasswordForUsernameCalled = false
    var saveSessionDataCalled = false
    var deleteSessionDataCalled = false
    
    var username: String? {
        get {
            usernameReturned = true
            return "username"
        }
    }
    
    /** Saves the users username to the standard defaults */
    func setUsername(username: String) {
        setUsernameCalled = true
    }
    
    /** Saves a users username and password. */
    func savePassword(password: String, forUsername username: String) throws {
        savePasswordForUsernameCalled = true
    }
    
    /** Saves a session cookie, token and current user uid to NSUserDefaults */
    func saveSessionData(sessionCookie: String, token: String, uid: Int) {
        saveSessionDataCalled = true
    }
    
    /** Deletes the session cookie, token and current user uid from NSUserDefaults */
    func deleteSessionData(sessionCookie: String, token: String, uid: Int) {
        deleteSessionDataCalled = true
    }
}