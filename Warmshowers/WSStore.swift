//
//  WSStore.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

class WSStore : NSObject {
    
    static let sharedStore = WSStore()
    
    // Set the map tiel expiry time to 24 hr
    static let MapTileExpiryTime: NSTimeInterval = 60.0 * 60.0 * 24.0
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        
    private override init() {
        super.init()
        privateContext.persistentStoreCoordinator = moc.persistentStoreCoordinator
        
        // Set up an observer to merge changes in the private context to the main context when it is saved
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WSStore.privateContextDidSave(_:)), name: NSManagedObjectContextDidSaveNotification, object: privateContext)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: Generic methods
    
    // Saves the private content
    class func savePrivateContext() throws {
        if sharedStore.privateContext.hasChanges {
            do {
                try sharedStore.privateContext.save()
            }
        }
    }
    
    // Merges the private context with the main context on notification
    func privateContextDidSave(notification:NSNotification)
    {
        WSStore.sharedStore.moc.performSelectorOnMainThread(#selector(NSManagedObjectContext.mergeChangesFromContextDidSaveNotification(_:)), withObject: notification, waitUntilDone: false)
    }
    
    // Initialise a NSFetchRequest for a given entity
    class func requestForEntity(entity: WSEntity) -> NSFetchRequest {
        let request = NSFetchRequest(entityName: entity.rawValue)
        return request
    }
    
    // Excecutes a syncronous fetch request with the private context
    //
    class func executeFetchRequest(request: NSFetchRequest) throws -> [AnyObject] {
        
        var objects = [AnyObject]()
        var error: NSError?
        sharedStore.privateContext.performBlockAndWait { () -> Void in
            do {
                objects = try sharedStore.privateContext.executeFetchRequest(request)
            } catch let nserror as NSError {
                error = nserror
            }
        }
        
        guard error == nil else {
            throw error!
        }
        
        return objects
    }
    
    // Syncronous fetch of all entries in an entity
    //
    class func getAllFromEntity(entity: WSEntity) throws -> [AnyObject] {
        
        let request = requestForEntity(entity)
        
        do {
            let objects = try executeFetchRequest(request)
            return objects
        }
    }
    
    // Deletes all objects from the store
    //
    class func clearout() throws {
    
        // Cycle through entities and delete all entries
        let entities = WSEntity.allValues
        do {
            for entity in entities {
                let objects = try WSStore.getAllFromEntity(entity) as! [NSManagedObject]
                for object in objects {
                    sharedStore.privateContext.deleteObject(object)
                    try savePrivateContext()
                }
            }
        }
    }
    
}

