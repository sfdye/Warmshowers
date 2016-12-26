//
//  SecureStoreDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/06/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public protocol SecureStoreDelegate {
    
    /** Saves the users OAuth token and secret. */
    func setToken(_ token: String, andSecret secret: String) throws
 
    /** Returns the users username. */
    func getTokenAndSecret() throws -> (String, String)
    
    /** Removes the token and secret from the secure store. */
    func revokeAccess() throws
    
}
