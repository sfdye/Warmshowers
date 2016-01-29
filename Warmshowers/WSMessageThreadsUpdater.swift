//
//  WSMessageThreadsUpdater.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 23/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

// This class is for downloading message thread data from warmshowers and updating the persistant store
//
class WSMessageThreadsUpdater : WSRequestWithCSRFToken, WSRequestDelegate {
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var queue = NSOperationQueue()
    
    override init() {
        super.init()
        requestDelegate = self
        queue.maxConcurrentOperationCount = 1
    }
    
    func requestForDownload() -> NSURLRequest? {
        let service = WSRestfulService(type: .getAllMessageThreads)!
        let request = WSRequest.requestWithService(service, token: token)
        return request
    }
    
    func doWithData(data: NSData) {
        
        guard let json = dataAsJSON() else {
            return
        }

        do {
            try saveMessageThreadsWithJSON(json)
        } catch let error {
            self.error = error as NSError
        }
    }
    
    // Parses JSON containing message threads
    //
    func saveMessageThreadsWithJSON(json: AnyObject) throws {
        
        guard let json = json as? NSArray else {
            throw DataError.InvalidInput
        }
        
        // Parse the json
        var currentThreadIDs = [Int]()
        for threadJSON in json {
            
            // Fail parsing if a message thread doesn't have an ID as it will cause problems later
            guard let threadID = threadJSON.valueForKey("thread_id")?.integerValue else {
                throw DataError.InvalidInput
            }
            
            // Save the thread id
            currentThreadIDs.append(threadID)
            
            // Retrive the thread from the store or save a new one
            let messageThread = CDWSMessageThread.newOrExistingMessageThread(threadID)
            do {
                try messageThread.updateWithJSON(threadJSON)
            }
        }
        
        // Save the message threads to the store
        do {
            try moc.save()
        }
        
        // Delete all threads that are not in the json
        var allMessageThreads: [CDWSMessageThread]
        do {
            allMessageThreads = try CDWSMessageThread.allMessageThreads()
            for messageThread in allMessageThreads {
                if let threadID = messageThread.thread_id?.integerValue {
                    if !(currentThreadIDs.contains(threadID)){
                        moc.deleteObject(messageThread)
                    }
                }
            }
        }
        
        // Save the deletions
        do {
            try moc.save()
        }
    }
    
    // Starts the message thread updates
    //
    func update() {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
        dispatch_async(queue) { () -> Void in
            self.tokenGetter.start()
        }
    }
    
}