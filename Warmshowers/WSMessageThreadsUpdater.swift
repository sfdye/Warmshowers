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
    
    override init(success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        super.init(success: success, failure: failure)
        requestDelegate = self
    }
    
    func requestForDownload() throws -> NSURLRequest {
        do {
            let service = WSRestfulService(type: .GetAllMessageThreads)!
            let request = try WSRequest.requestWithService(service, token: token)
            return request
        }
    }
    
    func doWithData(data: NSData) {
        
        guard let json = dataAsJSON() else {
            return
        }
        
        guard let threadsJSON = json as? NSArray else {
            setError(201, description: "Failed to convert message thread JSON.")
            return
        }
        
        WSStore.sharedStore.privateContext.performBlockAndWait { () -> Void in

            // Parse the json
            var currentThreadIDs = [Int]()
            for threadJSON in threadsJSON {
                
                // Fail parsing if a message thread doesn't have an ID as it will cause problems later
                guard let threadID = threadJSON.valueForKey("thread_id")?.integerValue else {
                    self.setError(202, description: "Thread ID missing in message thread JSON.")
                    return
                }
                
                do {
                    try WSStore.addMessageThread(threadJSON)
                } catch let nserror as NSError {
                    self.error = nserror
                    return
                }
                
                // Save the thread id
                currentThreadIDs.append(threadID)
            }
            
            // Delete all threads that are not in the json
            do {
                let allMessageThreads = try WSStore.allMessageThreads()
                for messageThread in allMessageThreads {
                    if let threadID = messageThread.thread_id?.integerValue {
                        if !(currentThreadIDs.contains(threadID)){
                            WSStore.sharedStore.privateContext.deleteObject(messageThread)
                        }
                    }
                }
                try WSStore.savePrivateContext()
            } catch let error as NSError {
                self.error = error
                return
            }
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