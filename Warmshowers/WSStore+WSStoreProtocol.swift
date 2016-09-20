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
                    if let entityName = entity.name , entityName != WSMOMapTile.entityName {
                        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
                        let objects = try context.fetch(request)
                        for object in objects {
                            context.delete(object)
                        }
                    }
                }
                try context.save()
            }
        }
    }
    
    func retrieve<T: NSManagedObject>(_ entityClass: T.Type, sortBy: String? = nil, isAscending: Bool = true, predicate: NSPredicate? = nil, context: NSManagedObjectContext = WSStore.sharedStore.managedObjectContext) throws -> [T] {
            let request : NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
            request.returnsObjectsAsFaults = false
            request.predicate = predicate
            
            if (sortBy != nil) {
                let sorter = NSSortDescriptor(key:sortBy , ascending:isAscending)
                request.sortDescriptors = [sorter]
            }
            
            do {
                let fetchedResult = try context.fetch(request)
                return fetchedResult
            }
    }
    
    func newOrExisting<T: NSManagedObject>(_ entityClass: T.Type, withJSON json: AnyObject, context: NSManagedObjectContext = WSStore.sharedStore.managedObjectContext) throws -> T where T: JSONUpdateable {
        do {
            let predicate = try T.predicate(fromJSON: json)
            if let exisitng = try retrieve(entityClass, sortBy: nil, isAscending: true, predicate: predicate, context: context).first {
                try exisitng.update(withJSON: json)
                return exisitng
            } else {
                let newEntry = NSEntityDescription.insertNewObject(forEntityName: entityClass.entityName, into: context) as! T
                try newEntry.update(withJSON: json)
                return newEntry
            }
        }
    }
    
    func performBlockInPrivateContextAndWait(_ block: @escaping (NSManagedObjectContext) throws -> Void) throws {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = WSStore.sharedStore.managedObjectContext
        var blockError: Error?
        privateContext.performAndWait({
            do {
                try block(privateContext)
            } catch {
                blockError = error
            }
        })
        if let error = blockError { throw error }
    }

}
