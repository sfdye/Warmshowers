//
//  WSSaveMessagesToStoreOperation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 25/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

class WSSaveMessagesToStoreOperation : NSOperation {
    
    var json: NSArray!
    var updater: WSMessageUpdater!
    var completion: () -> Void
    var moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    init(json: NSArray, forUpdater updater: WSMessageUpdater, completion: () -> Void) {
        self.json = json
        self.updater = updater
        self.completion = completion
        super.init()
    }
    
    override func main() {
        
        defer {
            completion()
        }
        
        // Unsupress completion handlers so the updater can end
        updater.callCompletionHandler = true
        
        do {
            try parseMessagesJSON()
        } catch let error {
            let nserror = error as NSError
            updater.error = nserror
        }
        
    }
    
    func parseMessagesJSON() throws {
        
        // Parse the json
        var currentMessageIDs = [Int]()
        for messageJSON in json {
            
            // Fail parsing if a message thread doesn't have an ID as it will cause problems later
            guard let messageID = messageJSON.valueForKey("mid")?.integerValue else {
                throw DataError.InvalidInput
            }
            
            // Save the thread id
            currentMessageIDs.append(messageID)
            
            // Get the message thread from the store
            if let thread = CDWSMessageThread.messageThreadWithID(updater.threadID) {
                
                // Retrive the thread from the store or save a new one
                let message = CDWSMessage.newOrExistingMessage(messageID)
                message.thread = thread
                do {
                    try message.updateWithJSON(messageJSON)
                }
                
            } else {
                throw CDWSMessageThreadError.ThreadWithIDNotFound(id: updater.threadID)
            }
        }
        
        // Save the message threads to the store
        do {
            try moc.save()
        }
        
        // Delete all threads that are not in the json
        if let allMessages = CDWSMessageThread.allMessagesOnThread(updater.threadID) {
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
            try moc.save()
        }
    }
    
}