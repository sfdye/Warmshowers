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
    var messageThread: CDWSMessageThread
    var moc: NSManagedObjectContext!
    var updater: WSMessageThreadUpdater!
    var completion: () -> Void
    
    init(messagesJSON: NSArray, forUpdater updater: WSMessageThreadUpdater, completion: () -> Void) {
        self.messagesJSON = messagesJSON
        self.updater = updater
        self.completion = completion
        self.messageThread = updater.messageThread
        self.moc = updater.moc
        super.init()
    }
    
    override func main() {
        
        // Unsupress completion handlers so the updater can end
        updater.callCompletionHandler = true
        
        // Delete old records
        if let messages = messageThread.messages?.allObjects as? [CDWSMessage] {
            for message in messages {
                moc.deleteObject(message)
            }
        }
        
        // Parse the json
        var messages = [CDWSMessage]()
        for messageJSON in messagesJSON {
            do {
                let message = try messageWithJSON(messageJSON, forMessageThread: messageThread)
                messages.append(message)
                if let new = message.is_new {
                    messageThread.is_new = new
                }
            } catch let error as NSError {
                updater.error = error
                completion()
                return
            }
        }
        
        // Update the message thread
        messageThread.messages = NSSet(array: messages)
        
        // Save the updates to the store
        do {
            try moc.save()
        } catch let error as NSError {
            moc.rollback()
            updater.error = error
        }
        
        completion()
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
        
        // Find the author in the store or make a new user record
        var author: CDWSUser
        do {
            author = try getUserWithUID(authorUID)
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
    
    // Checks if a user is already in the store by uid.
    // Returns the existing user, or a new user inserted into the MOC.
    //
    func getUserWithUID(uid: Int) throws -> CDWSUser {
        
        let request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "uid == %i", uid)
        
        // Try to find the user in the store
        do {
            let users = try moc.executeFetchRequest(request)
            if users.count != 0 {
                if let user = users[0] as? CDWSUser {
                    return user
                }
            }
        } catch {
            throw CoreDataError.FailedFetchReqeust
        }
        
        // User wasn't in the store, so create a new managed object
        let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as! CDWSUser
        return user
    }

}