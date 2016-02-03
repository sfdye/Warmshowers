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
    
    var store: WSMessageStore!
    
    init(store: WSMessageStore) {
        super.init()
        requestDelegate = self
        self.store = store
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
        
        guard let threadsJSON = json as? NSArray else {
            error = NSError(domain: "WSRequesterDomain", code: 40, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to convert message thread JSON.", comment: "")])
            return
        }
        
        //        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        //        let privateMOC = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
//        privateMOC.parentContext = moc
        
        // Don't call completion handlers until the block has finished
        
        store.privateContext.performBlockAndWait { () -> Void in
            
            // Parse the json
            var currentThreadIDs = [Int]()
            for threadJSON in threadsJSON {
                
                // Fail parsing if a message thread doesn't have an ID as it will cause problems later
                guard let threadID = threadJSON.valueForKey("thread_id")?.integerValue else {
                    self.error = NSError(domain: "WSRequesterDomain", code: 41, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Thread ID missing in message thread JSON.", comment: "")])
                    return
                }
                
                do {
                    print("adding message thread")
                    try self.store.addMessageThread(threadJSON)
                } catch let nserror as NSError {
                    self.error = nserror
                    return
                }
                
                // Save the thread id
                currentThreadIDs.append(threadID)
            }
            
            // Delete all threads that are not in the json
            do {
                let allMessageThreads = try self.store.allMessageThreads()
                for messageThread in allMessageThreads {
                    if let threadID = messageThread.thread_id?.integerValue {
                        if !(currentThreadIDs.contains(threadID)){
                            print("deleting thread")
                            self.store.privateContext.deleteObject(messageThread)
                        }
                    }
                }
                print("saving delete changes")
                try self.store.savePrivateContext()
            } catch let error as NSError {
                self.error = error
                return
            }
        }
    }
    //                // Fail parsing if a message thread doesn't have an ID as it will cause problems later
    //                guard let threadID = threadJSON.valueForKey("thread_id")?.integerValue else {
    //                    self.error = NSError(domain: "WSRequesterDomain", code: 41, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Thread ID missing in message thread JSON.", comment: "")])
    //                    return
    //                }
    //
    //                // Retrive the thread from the store or save a new one
    //                let messageThread = CDWSMessageThread.newOrExistingMessageThread(threadID, inContext: privateMOC)
    //                do {
    //                    try messageThread.updateWithJSON(threadJSON)
    //                } catch let error as NSError {
    //                    self.error = error
    //                    return
    //                }
//}

//            // Save the message threads to the store
//            do {
//                print("saving message threads")
//                try privateMOC.save()
//            } catch let error as NSError {
//                self.error = error
//                return
//            }
    
    
    
    
    // Starts the message thread updates
    //
    func update() {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
        dispatch_async(queue) { () -> Void in
            self.tokenGetter.start()
        }
    }
    
}