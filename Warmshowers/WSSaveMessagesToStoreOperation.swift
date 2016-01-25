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
    
    var messagesJSON: NSArray!
    var moc: NSManagedObjectContext!
    var messageThread: CDWSMessageThread!
    var success: (() -> Void)?
    var failure: (() -> Void)?
    
    init(messagesJSON: NSArray, moc: NSManagedObjectContext, messageThread: CDWSMessageThread) {
        super.init()
        self.messagesJSON = messagesJSON
        self.moc = moc
        self.messageThread = messageThread
    }
    
    override func main() {
        
        print("parsing json")
        
        var messages = [CDWSMessage]()
        
        // Parse the json
        for messageJSON in messagesJSON {
            do {
                print("parsing message")
                let message = try self.messageWithJSON(messageJSON, forMessageThread: messageThread)
                messages.append(message)
                if let new = message.is_new {
                    messageThread.is_new = new
                }
                print("done.")
            } catch DataError.InvalidInput {
                print("Failed to save message due to invalid input")
            } catch CoreDataError.FailedFetchReqeust {
                print("Failed to save message due to a failed Core Data fetch request")
            } catch {
                print("Failed to create message participant for an unknown error")
            }
        }
        
        // Update the message thread
        print("setting messages to thread")
        self.messageThread.messages = NSSet(array: messages)
        
        print("saving context")
        // Save the updates to the store
        do {
            try self.moc.save()
            self.success?()
        } catch {
            moc.rollback()
            self.failure?()
        }
    }
    
    // Converts JSON data for a single message threads into a managed object
    //
    func messageWithJSON(json: AnyObject, forMessageThread messageThread: CDWSMessageThread) throws -> CDWSMessage {
        
        // Abort if the message id can not be found.
        guard let message_id = json.valueForKey("mid")?.integerValue else {
            print("Recieved message with no ID")
            throw DataError.InvalidInput
        }
        
        guard let authorUID = json.valueForKey("author")?.integerValue else {
            print("Recieved message with no author")
            throw DataError.InvalidInput
        }
        
        guard let author = messageThread.participantWithUID(authorUID) else {
            print("Author no in the thread participants")
            throw DataError.InvalidInput
        }
        
        // Create a new message object in the moc
        let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: moc) as! CDWSMessage
        message.author = author
        
        // Update the message thread
        do {
            try message.updateWithJSON(json)
        } catch {
            print("Failed to update message thread with id \(message_id)")
        }
        
        return message
    }

}