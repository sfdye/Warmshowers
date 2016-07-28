//
//  WSStore.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

// Error types
enum DataError : ErrorType {
    case InvalidInput
    case FailedConversion
}

class WSStore : NSObject {
    
    static let sharedStore = WSStore()
    
    let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    
    // MARK: Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.example.test" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Warmshowers", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Warmshowers.sqlite")
        let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                       NSInferMappingModelAutomaticallyOption: true]
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "com.rajanfernandez.Warmshowers.ErrorDomain", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    
    // MARK: Life cycle
    
    private override init() {
        super.init()
        privateContext.persistentStoreCoordinator = managedObjectContext.persistentStoreCoordinator
        
        // Set up an observer to merge changes in the private context to the main context when it is saved
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(privateContextDidSave(_:)), name: NSManagedObjectContextDidSaveNotification, object: privateContext)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // Merges the private context with the main context on notification
    func privateContextDidSave(notification:NSNotification)
    {
        managedObjectContext.performSelectorOnMainThread(#selector(NSManagedObjectContext.mergeChangesFromContextDidSaveNotification(_:)), withObject: notification, waitUntilDone: false)
    }
    
    /** Returns the name of the entity with the given managed object class name. */
    func entityNameFromEntityClass(entityClass: NSManagedObject.Type) throws -> String {
        let className = NSStringFromClass(entityClass)
        let entities = managedObjectModel.entities
        for entity in entities {
            if entity.managedObjectClassName == className {
                return entity.name!
            }
        }
        throw PSStoreError.InvalidEntity
    }
    
}

