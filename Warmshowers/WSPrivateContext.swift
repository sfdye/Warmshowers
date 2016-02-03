//
//  WSPrivateContext.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

class WSPrivateContext {
    
    static var privateContext: NSManagedObjectContext {
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = moc.persistentStoreCoordinator
        return privateContext
    }
    
    // Fetches objects with a private context as per the provided fetch request
    //
    static func fetchObjects(request: NSFetchRequest) throws -> [AnyObject]? {
    
        var objects: [AnyObject]?
        var error: NSError?
        privateContext.performBlockAndWait { () -> Void in
            do {
                objects = try privateContext.executeFetchRequest(request)
                print("fetched all: \(objects)")
            } catch let nserror as NSError {
                error = nserror
            }
        }
        
        guard error == nil else {
            throw error!
        }
        
        return objects
    }
    
    // Fetches the first matching object with a private context as per the provided fetch request
    //
    static func fetchObject(request: NSFetchRequest) throws -> AnyObject? {
        
        var object: AnyObject?
        var error: NSError?
        privateContext.performBlockAndWait { () -> Void in
            do {
                object = try privateContext.executeFetchRequest(request).first
            } catch let nserror as NSError {
                error = nserror
            }
        }
        
        guard error == nil else {
            throw error!
        }
        
        return object
    }
    
}