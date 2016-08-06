//
//  WSStore+WSStoreProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 8/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

extension WSStore: WSStoreProtocol {
    
    func clearout() throws {
        let entities = managedObjectModel.entities
        do {
            try performBlockInPrivateContextAndWait { (context) throws in
                for entity in entities {
                    if let entityName = entity.name where entityName != WSMOMapTile.entityName {
                        let request = NSFetchRequest(entityName: entityName)
                        let objects = try context.executeFetchRequest(request) as! [NSManagedObject]
                        for object in objects {
                            context.deleteObject(object)
                        }
                    }
                }
                try context.save()
            }
        }
    }
    
    func retrieve<T: NSManagedObject where T: JSONUpdateable>(entityClass: T.Type, sortBy: String? = nil, isAscending: Bool = true, predicate: NSPredicate? = nil, context: NSManagedObjectContext = WSStore.sharedStore.managedObjectContext) throws -> [T] {
        do {
            // Execute a fetch with the given criteria.
            let request = NSFetchRequest(entityName: entityClass.entityName)
            request.returnsObjectsAsFaults = false
            request.predicate = predicate
            
            if (sortBy != nil) {
                let sorter = NSSortDescriptor(key:sortBy , ascending:isAscending)
                request.sortDescriptors = [sorter]
            }
            
            let fetchedResult = try context.executeFetchRequest(request) as! [T]
            return fetchedResult
        }
    }
    
    func newOrExisting<T: NSManagedObject where T: JSONUpdateable>(entityClass: T.Type, withJSON json: AnyObject, context: NSManagedObjectContext = WSStore.sharedStore.managedObjectContext) throws -> T {
        do {
            let predicate = try entityClass.predicateFromJSON(json)
            if let exisitng = try retrieve(entityClass, sortBy: nil, isAscending: true, predicate: predicate, context: context).first {
                try exisitng.update(json)
                return exisitng
            } else {
                let newEntry = NSEntityDescription.insertNewObjectForEntityForName(entityClass.entityName, inManagedObjectContext: context) as! T
                try newEntry.update(json)
                return newEntry
            }
        }
    }
    
    func performBlockInPrivateContextAndWait(block: (NSManagedObjectContext) throws -> Void) throws {
        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateContext.parentContext = WSStore.sharedStore.managedObjectContext
        var blockError: ErrorType?
        privateContext.performBlockAndWait({
            do {
                try block(privateContext)
            } catch {
                blockError = error
            }
        })
        if let error = blockError { throw error }
    }

}