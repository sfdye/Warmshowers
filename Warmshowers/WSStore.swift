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
enum DataError : ErrorProtocol {
    case invalidInput
    case failedConversion
}

class WSStore : NSObject {
    
    static let sharedStore = WSStore()
    
    let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    // MARK: Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.example.test" in the application's documents Application Support directory.
        let urls = FileManager.default().urlsForDirectory(.documentDirectory, inDomains: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main().urlForResource("Warmshowers", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = try! self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
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
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    
    // MARK: Life cycle
    
    private override init() {
        super.init()
        privateContext.persistentStoreCoordinator = managedObjectContext.persistentStoreCoordinator
        
        // Set up an observer to merge changes in the private context to the main context when it is saved
        NotificationCenter.default().addObserver(self, selector: #selector(privateContextDidSave(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: privateContext)
    }
    
    deinit {
        NotificationCenter.default().removeObserver(self)
    }
    
    // Merges the private context with the main context on notification
    func privateContextDidSave(_ notification:Notification)
    {
        managedObjectContext.performSelector(onMainThread: #selector(NSManagedObjectContext.mergeChanges(fromContextDidSave:)), with: notification, waitUntilDone: false)
    }
    

    // MARK: Generic methods
    
    /** Saves the private content. */
    func savePrivateContext() throws {
        if privateContext.hasChanges {
            do {
                try privateContext.save()
            }
        }
    }
    
    /** Initialises a NSFetchRequest for a given entity. */
    func requestForEntity(_ entity: WSEntity) -> NSFetchRequest<AnyObject> {
        let request = NSFetchRequest(entityName: entity.rawValue)
        return request
    }
    
    // Excecutes a syncronous fetch request with the private context
    //
    func executeFetchRequest(_ request: NSFetchRequest<AnyObject>) throws -> [AnyObject] {
        
        var objects = [AnyObject]()
        var error: NSError?
        privateContext.performAndWait { () -> Void in
            do {
                objects = try self.privateContext.fetch(request)
            } catch let nserror as NSError {
                error = nserror
            }
        }
        
        guard error == nil else {
            throw error!
        }
        
        return objects
    }
    
    /** Syncronous fetch of all entries in an entity. */
    func getAllEntriesFromEntity(_ entity: WSEntity) throws -> [AnyObject] {
        
        let request = requestForEntity(entity)
        
        do {
            let objects = try executeFetchRequest(request)
            return objects
        }
    }
}

