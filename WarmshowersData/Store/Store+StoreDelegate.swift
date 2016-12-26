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
                let request = NSFetchRequest<NSManagedObject>(entityName: entity.description)
                let objects = try context.fetch(request)
                for object in objects {
                    context.delete(object)
                }
            }
            try context.save()
        }
    }
    
    public func retrieve<T: NSManagedObject>(inContext context: NSManagedObjectContext, withPredicate predicate: NSPredicate? = nil, andSortBy sortBy: String? = nil, isAscending: Bool = true) throws -> [T] {
        
        var sorter: NSSortDescriptor? = nil
        if (sortBy != nil) {
            sorter = NSSortDescriptor(key: sortBy, ascending: isAscending)
        }
        
        let request = T.fetchRequest() as! NSFetchRequest<T>
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        if (sorter != nil) { request.sortDescriptors = [sorter!] }
        
        let fetchedResult = try context.fetch(request)
        return fetchedResult
    }
    
    func newOrExisting<T: NSManagedObject>(inContext context: NSManagedObjectContext, withJSON json: Any, withParser parser: JSONParser) throws -> T where T : JSONUpdateable {
        let predicate = try T.predicate(fromJSON: json, withParser: jsonParser)
        if let exisitng: T = try retrieve(inContext: context, withPredicate: predicate, andSortBy: nil, isAscending: true).first {
            try exisitng.update(withJSON: json, withParser: parser)
            return exisitng
        } else {
            let newEntry = T.init(context: context)
            return newEntry
        }
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
