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
    
    /** The main queue managed object context. */
    var managedObjectContext: NSManagedObjectContext { get }
    
    /** Deletes all persisted data. */
    func clearout() throws
    
    /** Syncronous fetch of all entries in an entity. */
    func retrieve<T: NSManagedObject>(objectsWithClass modelClass: T.Type, sortBy: String?, isAscending: Bool, predicate: NSPredicate?, context: NSManagedObjectContext) throws -> [T]
    
    /**
     Retrieves an existing entry or a new one if no matches exist.
     If no JSON is provided, a new entry is returned.
     The returned object properties are updated from the given JSON.
     */
    func newOrExisting<T: NSManagedObject>(ofClass modelClass: T.Type, withJSON json: Any, context: NSManagedObjectContext) throws -> T where T: JSONUpdateable
    
    /** Performs a synchronous block in a private context. */
    func performBlockInPrivateContextAndWait(_ block: @escaping (NSManagedObjectContext) throws -> Void) throws
    
}
