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
    var queue: NSOperationQueue!
    var callCompletionHandler = true
    var saveOperation: WSSaveMessagesToStoreOperation?
    
    init(messageThread: CDWSMessageThread, queue: NSOperationQueue) {
        super.init()
        requestDelegate = self
        self.messageThread = messageThread
        self.queue = queue
    }
    
    override func shouldStart() -> Bool {
        
        // Check the thread has an id
        guard let _ = messageThread.thread_id?.integerValue, let _ = token else {
            return false
        }
        return true
    }
    
    func requestForDownload() -> NSURLRequest? {
        
        guard let threadID = messageThread.thread_id?.integerValue else {
            error = NSError(domain: "WSRequesterDomain", code: 40, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Invalid message thread ID.", comment: "")])
            return nil
        }
        
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

        // Create an operation to save the messages
        saveOperation = WSSaveMessagesToStoreOperation(messagesJSON: messagesJSON, forUpdater: self, completion: self.saveOperationCompleted)
        self.queue.addOperation(saveOperation!)
    }
    
    // Suppress calling the completion handler as it will be call when the save operation is finished
    //
    override func shouldCallCompletionHandler() -> Bool {
        return saveOperation == nil
    }
    
    // A completion method for the save operation to call
    //
    func saveOperationCompleted() {
        saveOperation = nil
        end()
    }
}