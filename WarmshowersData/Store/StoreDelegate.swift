//
//  StoreDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 14/06/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

public protocol StoreDelegate {
    
    /** The main queue managed object context. */
    var managedObjectContext: NSManagedObjectContext { get }
    
    /** Deletes all persisted data. */
    func clearout() throws
    
    /** Syncronous fetch of all entries in an entity. */
    func retrieve<T: NSManagedObject>(inContext context: NSManagedObjectContext, withPredicate predicate: NSPredicate?, andSortBy sortBy: String?, isAscending: Bool) throws -> [T]
    
}

protocol StoreUpdateDelegate {
    
    /** Syncronous fetch of all entries in an entity. */
    func retrieve<T: NSManagedObject>(inContext context: NSManagedObjectContext, withPredicate predicate: NSPredicate?, andSortBy sortBy: String?, isAscending: Bool) throws -> [T] where T: JSONUpdateable
    
    /**
     Retrieves an existing entry or a new one if no matches exist.
     If no JSON is provided, a new entry is returned.
     The returned object properties are updated from the given JSON.
     */
    func newOrExisting<T: NSManagedObject>(inContext context: NSManagedObjectContext, withJSON json: Any, withParser parser: JSONParser) throws -> T where T: JSONUpdateable
    
    /** Performs a synchronous block in a private context. */
    func performBlockInPrivateContextAndWait(_ block: @escaping (NSManagedObjectContext) throws -> Void) throws
    
}
