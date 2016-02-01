//
//  WSMessageUpdater.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

class WSMessageUpdater : WSRequestWithCSRFToken, WSRequestDelegate {
    
    var threadID: Int!
    var callCompletionHandler = true
    
    init(threadID: Int) {
        super.init()
        requestDelegate = self
        self.threadID = threadID
//        self.parsingQueue = parsingQueue
    }
    
    func requestForDownload() -> NSURLRequest? {
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
        
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let privateMOC = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateMOC.parentContext = moc
        
        privateMOC.performBlock {
            
            // Parse the json
            var currentMessageIDs = [Int]()
            for messageJSON in messagesJSON {
                
                // Fail parsing if a message thread doesn't have an ID as it will cause problems later
                guard let messageID = messageJSON.valueForKey("mid")?.integerValue else {
                    self.error = NSError(domain: "WSRequesterDomain", code: 31, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Messages JSON missing message id key", comment: "")])
                    return
                }
                
                // Save the thread id
                currentMessageIDs.append(messageID)
                
                // Get the message thread from the store
                if let thread = CDWSMessageThread.messageThreadWithID(self.threadID) {
                    
                    // Retrive the thread from the store or save a new one
                    let message = CDWSMessage.newOrExistingMessage(messageID)
                    if message.thread == nil {
                        message.thread = thread
                    }
                    
                    do {
                        try message.updateWithJSON(messageJSON)
                    } catch let error as NSError {
                        privateMOC.deleteObject(message)
                        self.error = error
                        return
                    }
                    
                } else {
                    self.error = NSError(domain: "WSRequesterDomain", code: 33, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to find message thread with id \(self.threadID) in the store", comment: "")])
                    return
                }
            }
            
            // Save the message threads to the store
            do {
                try privateMOC.save()
            } catch let error as NSError {
                privateMOC.rollback()
                self.error = error
                return
            }
            
            // Delete all threads that are not in the json
            if let allMessages = CDWSMessageThread.allMessagesOnThread(self.threadID) {
                for message in allMessages {
                    if let messageID = message.message_id?.integerValue {
                        if !(currentMessageIDs.contains(messageID)){
                            moc.deleteObject(message)
                        }
                    }
                }
            }
            
            // Save the deletions
            do {
                try privateMOC.save()
            } catch let error as NSError {
                privateMOC.rollback()
                self.error = error
                return
            }
            
        }
    }
    
    // Initiates the update
    //
    func update() {
        self.tokenGetter.start()
    }
}