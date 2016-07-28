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
    
    func savePrivateContext() throws {
        if privateContext.hasChanges {
            do {
                try privateContext.save()
            }
        }
    }
    
    func clearout() throws {
        let entities = managedObjectModel.entities
        for entity in entities {
            do {
                if let entityName = entity.name {
                    let request = NSFetchRequest(entityName: entityName)
                    let objects = try privateContext.executeFetchRequest(request) as! [NSManagedObject]
                    for object in objects {
                        privateContext.deleteObject(object)
                    }
                    try savePrivateContext()
                }
            }
        }
    }
    
    func retrieve<T: NSManagedObject>(entityClass: T.Type, sortBy: String? = nil, isAscending: Bool = true, predicate: NSPredicate? = nil) throws -> [T] {
        do {
            // Get the entity name from the model.
            let entityName = try entityNameFromEntityClass(entityClass)
            
            // Execute a fetch with the given criteria.
            let request = NSFetchRequest(entityName: entityName)
            request.returnsObjectsAsFaults = false
            request.predicate = predicate
            
            if (sortBy != nil) {
                let sorter = NSSortDescriptor(key:sortBy , ascending:isAscending)
                request.sortDescriptors = [sorter]
            }
            
            let fetchedResult = try privateContext.executeFetchRequest(request) as! [T]
            return fetchedResult
        }
    }
    
    func newOrExisting<T: NSManagedObject where T: JSONUpdateable>(entityClass: T.Type, withJSON json: AnyObject) throws -> T {
        do {
            let predicate = try entityClass.predicateFromJSON(json)
            if let exisitng = try retrieve(entityClass, sortBy: nil, isAscending: true, predicate: predicate).first {
                try exisitng.update(json)
                return exisitng
            } else {
                let entityName = try entityNameFromEntityClass(entityClass)
                let newEntry = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: privateContext) as! T
                try newEntry.update(json)
                return newEntry
            }
        }
    }
    
    
//    /** Initialises a NSFetchRequest for a given entity. */
//    func requestForEntity(entity: WSEntity) -> NSFetchRequest {
//        let request = NSFetchRequest(entityName: entity.rawValue)
//        return request
//    }
//    
//    // Excecutes a syncronous fetch request with the private context
//    //
//    func executeFetchRequest(request: NSFetchRequest) throws -> [AnyObject] {
//        
//        var objects = [AnyObject]()
//        var error: NSError?
//        privateContext.performBlockAndWait { () -> Void in
//            do {
//                objects = try self.privateContext.executeFetchRequest(request)
//            } catch let nserror as NSError {
//                error = nserror
//            }
//        }
//        
//        guard error == nil else {
//            throw error!
//        }
//        
//        return objects
//    }
//    
//    /** Syncronous fetch of all entries in an entity. */
//    func getAllEntriesFromEntity(entity: WSEntity) throws -> [AnyObject] {
//        
//        let request = requestForEntity(entity)
//        
//        do {
//            let objects = try executeFetchRequest(request)
//            return objects
//        }
//    }

}