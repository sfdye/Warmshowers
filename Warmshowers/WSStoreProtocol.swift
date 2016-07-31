//
//  WSStoreProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 8/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

protocol WSStoreProtocol {
    
    /** Saves the private content. */
    func savePrivateContext() throws
    
    /** Deletes all persisted data. */
    func clearout() throws
    
    /** Syncronous fetch of all entries in an entity. */
    func retrieve<T: NSManagedObject>(entityClass: T.Type, sortBy: String?, isAscending: Bool, predicate: NSPredicate?) throws -> [T]
    
    /**
     Retrieves an existing entry or a new one if no matches exist.
     If no JSON is provided, a new entry is returned.
     The returned object properties are updated from the given JSON.
     The returned object exists in the private managed object context of the store.
     If the object is updated after being returned, the called should later call WSStoreDelegate.savePrivateContext() to ensure the changes are persisted.
     */
    func newOrExisting<T: NSManagedObject where T: JSONUpdateable>(entityClass: T.Type, withJSON json: AnyObject) throws -> T
    
}