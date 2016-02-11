//
//  WSMessageStore.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

enum WSMessageEntity : String {
    case Thread = "MessageThread"
    case Message = "Message"
    case User = "User"
    
    static let allValues = [Thread, Message, User]
}

class WSMessageStore : NSObject {
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        
    override init() {
        super.init()
        privateContext.persistentStoreCoordinator = moc.persistentStoreCoordinator
        
        // Set up an observer to merge changes in the private context to the main context when it is saved
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("privateContextDidSave:"), name: NSManagedObjectContextDidSaveNotification, object: self.privateContext)
    }
    
    
    // MARK: Generic methods
    
    // Saves the private content
    func savePrivateContext() throws {
        if privateContext.hasChanges {
            do {
                try privateContext.save()
            }
        }
    }
    
    // Merges the private context with the main context on notification
    func privateContextDidSave(notification:NSNotification)
    {
        moc.performSelectorOnMainThread(Selector("mergeChangesFromContextDidSaveNotification:"), withObject: notification, waitUntilDone: false)
    }
    
    // Initialise a NSFetchRequest for a given entity
    func requestForEntity(entity: WSMessageEntity) -> NSFetchRequest {
        let request = NSFetchRequest(entityName: entity.rawValue)
        return request
    }
    
    // Excecutes a syncronous fetch request with the private context
    //
    func executeFetchRequest(request: NSFetchRequest) throws -> [AnyObject] {
        
        var objects = [AnyObject]()
        var error: NSError?
        privateContext.performBlockAndWait { () -> Void in
            do {
                objects = try self.privateContext.executeFetchRequest(request)
            } catch let nserror as NSError {
                error = nserror
            }
        }
        
        guard error == nil else {
            throw error!
        }
        
        return objects
    }
    
    // Syncronous fetch of all entries in an entity
    //
    func getAllFromEntity(entity: WSMessageEntity) throws -> [AnyObject] {
        
        let request = requestForEntity(entity)
        
        do {
            let objects = try executeFetchRequest(request)
            return objects
        }
    }
    
    // Deletes all objects from the store
    //
    func clearout() throws {
    
        // Cycle through entities and delete all entries
        let entities = WSMessageEntity.allValues
        do {
            for entity in entities {
                let objects = try getAllFromEntity(entity) as! [NSManagedObject]
                for object in objects {
                    privateContext.deleteObject(object)
                    try savePrivateContext()
                }
            }
        }
    }
    
    
    // MARK: Message thread handling methods
    
    // Returns all the message threads in the store
    //
    func allMessageThreads() throws -> [CDWSMessageThread] {
        
        do {
            let threads = try getAllFromEntity(.Thread) as! [CDWSMessageThread]
            return threads
        }
    }
    
    // Checks if a message thread is already in the store by thread id.
    // Returns the existing message thread, or a new message thread inserted into the private context.
    //
    func messageThreadWithID(threadID: Int) throws -> CDWSMessageThread? {
        
        let request = requestForEntity(.Thread)
        request.predicate = NSPredicate(format: "thread_id==%i", threadID)
        
        var thread: CDWSMessageThread?
        do {
            thread = try executeFetchRequest(request).first as? CDWSMessageThread
        }
        return thread
    }
    
    // Checks if a message exists and returns it or a new one if it doesn't exist
    //
    func newOrExistingMessageThread(threadID: Int) throws -> CDWSMessageThread {
        do {
            if let thread = try messageThreadWithID(threadID) {
                return thread
            } else {
                let thread = NSEntityDescription.insertNewObjectForEntityForName(WSMessageEntity.Thread.rawValue, inManagedObjectContext: privateContext) as! CDWSMessageThread
                return thread
            }
        }
    }
    
    // Adds a message thread to the store with json
    //
    func addMessageThread(json: AnyObject) throws {
        
        guard let count = json.valueForKey("count")?.integerValue else {
            throw CDWSMessageThreadError.FailedValueForKey(key: "count")
        }
        
        guard let has_tokens = json.valueForKey("has_tokens")?.integerValue else {
            throw CDWSMessageThreadError.FailedValueForKey(key: "has_tokens")
        }
        
        guard let is_new = json.valueForKey("is_new")?.integerValue else {
            throw CDWSMessageThreadError.FailedValueForKey(key: "is_new")
        }
        
        guard let last_updated = json.valueForKey("last_updated")?.doubleValue else {
            throw CDWSMessageThreadError.FailedValueForKey(key: "last_updated")
        }
        
        guard let subject = json.valueForKey("subject") as? String else {
            throw CDWSMessageThreadError.FailedValueForKey(key: "subject")
        }
        
        guard let thread_id = json.valueForKey("thread_id")?.integerValue else {
            throw CDWSMessageThreadError.FailedValueForKey(key: "thread_id")
        }
        
        guard let thread_started = json.valueForKey("thread_started")?.doubleValue else {
            throw CDWSMessageThreadError.FailedValueForKey(key: "thread_started")
        }
        
        // Get the message participants, then save the message
        do {
            let thread = try newOrExistingMessageThread(thread_id)
            thread.count = count
            thread.has_tokens = has_tokens
            thread.is_new = is_new
            thread.last_updated = NSDate(timeIntervalSince1970: last_updated)
            thread.subject = subject
            thread.thread_id = thread_id
            thread.thread_started = NSDate(timeIntervalSince1970: thread_started)
            
            // Don't need change the message participants if they already exist
            if let participants = thread.participants where participants.count == 0 {
                
                guard let participantsJSON = json.valueForKey("participants") else {
                    throw DataError.InvalidInput
                }
                
                let participants = try userSetFromJSON(participantsJSON)
                thread.participants = participants
            }
            
            try savePrivateContext()
        }
    }
    
    // Returns the number of messages that have been saved to the store for a given thread
    func numberOfDownloadedMessagesOnThread(threadID: Int) throws -> Int {
        do {
            if let messageThread = try messageThreadWithID(threadID) {
                if let messages = messageThread.messages {
                    return messages.count
                }
            }
            return 0
        }
    }
    
    func numberOfUnreadMessageThreads() throws -> Int {
        do {
            let threads = try allMessageThreads() as NSArray
            let isNew = threads.valueForKey("is_new") as! [Int]
            let sum = isNew.reduce(0, combine: +)
            return sum
        }
    }
    
    func messageThreadsThatNeedUpdating() throws -> [Int] {
        do {
            var threadIDs = [Int]()
            let threads = try allMessageThreads()
            for thread in threads {
                if thread.needsUpdating() {
                    if let threadID = thread.thread_id?.integerValue {
                        threadIDs.append(threadID)
                    }
                }
            }
            return threadIDs
        }
    }
    
    func allMessagesOnThread(threadID: Int) throws -> [CDWSMessage]? {
        do {
            var messages: [CDWSMessage]?
            if let messageThread = try messageThreadWithID(threadID) {
                messages = messageThread.messages?.allObjects as? [CDWSMessage]
            }
            return messages
        }
    }
    
    func subjectForMessageThreadWithID(threadID: Int) -> String? {
        do {
            let messageThread = try messageThreadWithID(threadID)
            let subject = messageThread?.subject
            return subject
        } catch {
            return nil
        }
    }
    
    func markMessageThread(threadID: Int, unread: Bool) throws {
        do {
            let messageThread = try messageThreadWithID(threadID)
            messageThread?.is_new = unread
            try savePrivateContext()
        }
    }
    
    
    // MARK: Message handling methods
    
    // Returns all the messages in the store
    //
    func allMessages() throws -> [CDWSMessage] {
        
        do {
            let messages = try getAllFromEntity(.Message) as! [CDWSMessage]
            return messages
        }
    }
    
    // Checks if a message is already in the store by message id.
    // Returns the existing message, or a new message inserted into the private context.
    //
    func messageWithID(messageID: Int) throws -> CDWSMessage? {
        
        let request = requestForEntity(.Message)
        request.predicate = NSPredicate(format: "message_id==%i", messageID)
        
        var message: CDWSMessage?
        do {
            message = try executeFetchRequest(request).first as? CDWSMessage
        }
        return message
    }
    
    // Checks if a message exists and returns it or a new one if it doesn't exist
    //
    func newOrExistingMessage(messageID: Int) throws -> CDWSMessage {
        do {
            if let message = try messageWithID(messageID) {
                return message
            } else {
                let message = NSEntityDescription.insertNewObjectForEntityForName(WSMessageEntity.Message.rawValue, inManagedObjectContext: privateContext) as! CDWSMessage
                return message
            }
        }
    }
    
    // Adds a message to the store with json
    //
    func addMessage(json: AnyObject, onThreadWithID threadID: Int) throws {
        
        // JSON input checks
        guard let body = json.valueForKey("body") as? String else {
            throw CDWSMessageThreadError.FailedValueForKey(key: "count")
        }
        
        guard let message_id = json.valueForKey("mid")?.integerValue else {
            throw CDWSMessageThreadError.FailedValueForKey(key: "mid")
        }
    
        guard let timestamp = json.valueForKey("timestamp")?.doubleValue else {
            throw CDWSMessageThreadError.FailedValueForKey(key: "timestamp")
        }
        
        guard let is_new = json.valueForKey("is_new")?.boolValue else {
            throw CDWSMessageThreadError.FailedValueForKey(key: "is_new")
        }
        
        guard let author_uid = json.valueForKey("author")?.integerValue else {
            throw CDWSMessageThreadError.FailedValueForKey(key: "author")
        }
        
        // Get the message author and thread, then save the message
        do {
            let author = try newOrExistingUser(author_uid)
            let thread = try newOrExistingMessageThread(threadID)
            let message = try newOrExistingMessage(message_id)
            message.author = author
            message.thread = thread
            message.body = body
            message.message_id = message_id
            message.timestamp = NSDate(timeIntervalSince1970: timestamp)
            message.is_new = is_new
            try savePrivateContext()
        }
    }
    
    
    // MARK: User handling methods
    
    // Returns all the users in the store
    //
    func allUsers() throws -> [CDWSUser] {
        
        do {
            let users = try getAllFromEntity(.User) as! [CDWSUser]
            return users
        }
    }
    
    // Checks if a user is already in the store by uid.
    // Returns the existing user, or a new user inserted into the private context.
    //
    func userWithID(uid: Int) throws -> CDWSUser? {
        
        let request = requestForEntity(.User)
        request.predicate = NSPredicate(format: "uid == %i", uid)
        
        var user: CDWSUser?
        do {
            user = try executeFetchRequest(request).first as? CDWSUser
        }
        return user
    }
    
    func newOrExistingUser(uid: Int) throws -> CDWSUser {
        do {
            if let user = try userWithID(uid) {
                return user
            } else {
                let user = NSEntityDescription.insertNewObjectForEntityForName(WSMessageEntity.User.rawValue, inManagedObjectContext: privateContext) as! CDWSUser
                return user
            }
        }
    }
    
    // Create a user set from json containing message thread participants
    //
    func userSetFromJSON(json: AnyObject) throws -> NSSet {
        
        guard let users = json as? NSArray else {
            throw DataError.InvalidInput
        }
        
        var participants = [CDWSUser]()
        for user in users {
            
            // Get the user uid of the message participant.
            if let uid = user.valueForKey("uid")?.integerValue {
                
                // Check if the participant exists in the store.
                do {
                    var participant = try userWithID(uid)
                    if participant == nil {
                        try addUserWithParticipantJSON(user)
                        participant = try userWithID(uid)
                    }
                    participants.append(participant!)
                }
                
            } else {
                throw DataError.InvalidInput
            }
        }
        
        return NSSet(array: participants)
    }
    
    // Adds a user to the store with json describing a message participant
    //
    func addUserWithParticipantJSON(json: AnyObject) throws {
    
        guard let fullname = json.valueForKey("fullname") as? String else {
            throw CDWSMessageParticipantError.FailedValueForKey(key: "fullname")
        }
        
        guard let name = json.valueForKey("name") as? String else {
            throw CDWSMessageParticipantError.FailedValueForKey(key: "name")
        }
        
        guard let uid = json.valueForKey("uid")?.integerValue else {
            throw CDWSMessageParticipantError.FailedValueForKey(key: "uid")
        }
        
        do {
            let user = try newOrExistingUser(uid)
            user.fullname = fullname
            user.name = name
            user.uid = uid
            try savePrivateContext()
        }
    }
    
    // Updates a users profile thumbnail image url
    func updateUserImageURLWithJSON(json: AnyObject) throws {
        
        guard let uid = json.valueForKey("uid")?.integerValue else {
            throw DataError.InvalidInput
        }
        
        do {
            if let user = try userWithID(uid) {
                user.image_url = json.valueForKey("profile_image_map_infoWindow") as? String
                try savePrivateContext()
            } else {
                let error = NSError(domain: "WSMessageStore", code: 1, userInfo: [NSLocalizedDescriptionKey : "Can not update image url for user. User is not in the store."])
                throw error
            }
        }
    }
    
    // Update a user with a thumbnail image 
    func updateUser(uid: Int, withImage image: UIImage) throws {
        
        do {
            if let user = try userWithID(uid) {
                user.image = image
                try savePrivateContext()
            } else {
                let error = NSError(domain: "WSMessageStore", code: 2, userInfo: [NSLocalizedDescriptionKey : "Can not update image for user. User is not in the store."])
                throw error
            }
        }
    }
}

