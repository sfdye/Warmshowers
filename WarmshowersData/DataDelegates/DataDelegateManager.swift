//
//  DataDelegateManager.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/12/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public protocol DataDelegateManager {
    
    /** The api delegate is used for making newtorking requests. */
    var api: APIDelegate { get }
    
    /** The store delegate provides access to the persistant store. */
    var store: StoreDelegate { get }
    
    /** The secure store provides access to the keychain. */
    var secureStore: SecureStoreDelegate { get }
    
}
