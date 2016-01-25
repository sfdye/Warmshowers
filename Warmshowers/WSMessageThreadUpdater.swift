//
//  WSMessageThreadUpdater.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

class WSMessageThreadUpdater : WSRequestWithCSRFToken {
    
    var messageThread: CDWSMessageThread!
    var moc: NSManagedObjectContext!
    var queue: NSOperationQueue!
    
    init(messageThread: CDWSMessageThread, inManagedObjectContext moc: NSManagedObjectContext, queue: NSOperationQueue) {
        super.init()
        self.messageThread = messageThread
        self.moc = moc
        self.queue = queue
    }
    
    // Downloads messages and updates the thread
    //
    override func request() {
        
        guard let messageThread = messageThread, let token = tokenGetter.token else {
            failure?()
            return
        }
        
        guard let threadID = messageThread.thread_id?.integerValue else {
            failure?()
            return
        }
        
        // Guard against unneccessarily updating
        if !messageThread.needsUpdating() {
            success?()
            return
        }
        
        guard let service = WSRestfulService(type: .getMessageThread) else {
            failure?()
            return
        }
        
        let params: [String: String] = ["thread_id": String(threadID)]

        guard let request = WSRequest.requestWithService(service, params: params, token: token) else {
            failure?()
            return
        }
        
        task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            // Guard against failed http requests
            guard let data = data, let _ = response where error == nil else {
                self.failure?()
                return
            }

            guard let json = WSRequest.jsonDataToJSONObject(data) else {
                self.failure?()
                return
            }
            
            guard let messagesJSON = json.valueForKey("messages") as? NSArray else {
                self.failure?()
                return
            }
            
            let saveOperation = WSSaveMessagesToStoreOperation(messagesJSON: messagesJSON, moc: self.moc, messageThread: self.messageThread)
            saveOperation.success = self.success
            saveOperation.failure = self.failure
            self.queue.addOperation(saveOperation)
        })
        task.resume()
    }
    
}