//
//  WSSessionStateProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

protocol WSSessionStateProtocol {
    
    /** Returns the users uid if logged in or nil if no user is logged in. */
    var uid: Int? { get }
    
    /** Returns latest users username or nil if no username has been saved. */
    var username: String? { get }
    
    /** Saves the users username to the standard defaults. */
    func setUsername(username: String)
    
    /** Saves a users username and password. */
    func savePassword(password: String, forUsername username: String) throws
    
    /** Saves a session cookie, token and current user uid to NSUserDefaults. */
    func saveSessionData(sessionCookie: String, token: String, uid: Int)
    
    /** Deletes the session cookie, token and current user uid from NSUserDefaults. */
    func deleteSessionData()
    
    /** Saves a session CSRF token. */
    func setToken(token: String)
    
    /** Returns true is a user is logged in. */
    var isLoggedIn: Bool { get }
    
    /** Deletes the the users session data and navigates to the login screen. */
    func didLogoutFromView(viewContoller: UIViewController?)
    
}