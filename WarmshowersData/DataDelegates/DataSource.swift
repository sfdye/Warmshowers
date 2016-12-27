//
//  DataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/12/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public protocol DataSource {
    
    /** */
    var dataDelegates: DataDelegateManager { get }
    
    // Instructs the data source to clear any cached data.
    func invalidate()
    
    // Instructs the data source to update its data.
    func update()
    
    // Instructs the data source to persist its current data.
    func save()
    
}

extension DataSource {
    
    public var dataDelegates: DataDelegateManager {
        get {
            return DataDelegates.shared
        }
    }
    
    public var api: APIDelegate {
        get {
            return dataDelegates.api
        }
        set(new) {
            DataDelegates.shared.api = new
        }
    }
    
    public var store: StoreDelegate {
        get {
            return dataDelegates.store
        }
        set(new) {
            DataDelegates.shared.store = new
        }
    }
    
    public var secureStore: SecureStoreDelegate {
        get {
            return dataDelegates.secureStore
        }
        set(new) {
            DataDelegates.shared.secureStore = new
        }
    }
    
    // Default implementation of invalidate() is empty as it will not always be used.
    public func invalidate() { }
    
    // Default implementation of update() is empty as it will not always be used.
    public func update() { }
    
    // Default implementation of save() is empty as it will not always be used.
    public func save() { }
    
}
