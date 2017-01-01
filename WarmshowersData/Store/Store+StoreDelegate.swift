//
//  PSStoreManager+StoreDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 14/06/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

extension Store: StoreDelegate, StoreUpdateDelegate {
    
    public func clearout() throws {
        let entities = managedObjectModel.entities
        try performBlockInPrivateContextAndWait { (context) throws in
            for entity in entities {
                guard let entityName = entity.name else { continue }
                let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
                let objects = try context.fetch(request)
                for object in objects {
                    context.delete(object)
                }
            }
            try context.save()
        }
    }
    
    public func retrieve<T: NSManagedObject>(inContext context: NSManagedObjectContext, withPredicate predicate: NSPredicate? = nil, andSortBy sortBy: String? = nil, isAscending: Bool = true) throws -> [T] where T: Fetchable {
        
        var sorter: NSSortDescriptor? = nil
        if (sortBy != nil) {
            sorter = NSSortDescriptor(key: sortBy, ascending: isAscending)
        }
        
        let request = NSFetchRequest<T>(entityName: T.entityName)
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        if (sorter != nil) { request.sortDescriptors = [sorter!] }
        
        let fetchedResult = try context.fetch(request)
        return fetchedResult
    }
    
    func newOrExisting<T: NSManagedObject>(inContext context: NSManagedObjectContext, withJSON json: Any, withParser parser: JSONParser) throws -> T where T: JSONUpdateable & Fetchable {
        let predicate = try T.predicate(fromJSON: json, withParser: parser)
        var entry: T
        if let exisitng: T = try retrieve(inContext: context, withPredicate: predicate, andSortBy: nil, isAscending: true).first {
            entry = exisitng
        } else {
            let newEntry: T = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: context) as! T
            entry = newEntry
        }
        try entry.update(withJSON: json, withParser: parser)
        return entry
    }
    
    public func performBlockInPrivateContextAndWait(_ block: @escaping (NSManagedObjectContext) throws -> Void) throws {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = managedObjectContext
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
