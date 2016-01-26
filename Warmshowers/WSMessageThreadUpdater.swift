//
//  WSMessageThreadUpdater.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

class WSMessageThreadUpdater : WSRequestWithCSRFToken, WSRequestDelegate {
    
    var messageThread: CDWSMessageThread!
    var moc: NSManagedObjectContext!
    var queue: NSOperationQueue!
    
    init(messageThread: CDWSMessageThread, inManagedObjectContext moc: NSManagedObjectContext, queue: NSOperationQueue) {
        super.init()
        self.messageThread = messageThread
        self.moc = moc
        self.queue = queue
        queue.maxConcurrentOperationCount = 1
    }
    
    override func shouldStart() -> Bool {
        
        // Check the thread has an id
        guard let _ = messageThread.thread_id?.integerValue else {
            return false
        }
        
        // Guard against unneccessarily updating
        return messageThread.needsUpdating()
    }
    
    func requestForDownload() -> NSURLRequest? {
        let threadID = messageThread.thread_id?.integerValue
        let service = WSRestfulService(type: .getMessageThread)!
        let params: [String: String] = ["thread_id": String(threadID)]
        let request = WSRequest.requestWithService(service, params: params, token: token)
        return request
    }
    
    func doWithData(data: NSData) {
        
        guard let json = dataAsJSON() else {
            return
        }
        
        guard let messagesJSON = json.valueForKey("messages") as? NSArray else {
            error = NSError(domain: "WSRequesterDomain", code: 30, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Messages JSON missing messages key", comment: "")])
            return
        }
        
        let saveOperation = WSSaveMessagesToStoreOperation(messagesJSON: messagesJSON, moc: self.moc, messageThread: self.messageThread)
        saveOperation.success = {
            self.success?()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        saveOperation.failure = self.failure
        self.queue.addOperation(saveOperation)
    }
    
    // Suppress calling the completion handler as it will be call when the save operation is finished
    //
    override func shouldCallCompletionHandler() -> Bool {
        return false
    }
}