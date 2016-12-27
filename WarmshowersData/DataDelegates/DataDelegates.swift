//
//  DataDelegates.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/12/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

/**
 This singleton class holds a reference to all the data delegates that are
 used by data sources throughout the app (e.g. the api delegate, store
 delegate, etc).
 Note that this object does nothing but provide routing to the current instance
 of delegate obejcts. Therefore, testing is not required.
 */
class DataDelegates: DataDelegateManager {
    
    static var shared = DataDelegates()
    
    // MARK - Data Delegate manager
    
    var api: APIDelegate = APICommunicator()
    
    var store: StoreDelegate = Store()
    
    var secureStore: SecureStoreDelegate = SecureStore()
    
}
