//
//  WSSessionStateProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSSessionStateProtocol {
    
    /** Returns the users uid if logged in or nil if no user is logged in. */
    var uid: Int? { get }
    
    /** Returns latest users username or nil if no username has been saved. */
    var username: String? { get }
    
    /** Saves the users username to the standard defaults. */
    func setUsername(_ username: String)
    
    /** Saves a users username and password. */
    func savePassword(_ password: String, forUsername username: String) throws
    
    /** Saves a session cookie, token and current user uid to NSUserDefaults. */
    func saveSessionData(_ sessionCookie: String, token: String, uid: Int)
    
    /** Deletes the session cookie, token and current user uid from NSUserDefaults. */
    func deleteSessionData()
    
    /** Saves a session CSRF token. */
    func setToken(_ token: String)
    
    /** Returns true is a user is logged in. */
    var isLoggedIn: Bool { get }
}
