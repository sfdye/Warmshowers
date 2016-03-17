//
//  WSStore.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

class WSStore : NSObject {
    
    static let sharedStore = WSStore()
    
    // Set the map tiel expiry time to 24 hr
    static let MapTileExpiryTime: NSTimeInterval = 60.0 * 60.0 * 24.0
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        
    private override init() {
        super.init()
        privateContext.persistentStoreCoordinator = moc.persistentStoreCoordinator
        
        // Set up an observer to merge changes in the private context to the main context when it is saved
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("privateContextDidSave:"), name: NSManagedObjectContextDidSaveNotification, object: privateContext)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: Generic methods
    
    // Saves the private content
    class func savePrivateContext() throws {
        if sharedStore.privateContext.hasChanges {
            do {
                try sharedStore.privateContext.save()
            }
        }
    }
    
    // Merges the private context with the main context on notification
    func privateContextDidSave(notification:NSNotification)
    {
        WSStore.sharedStore.moc.performSelectorOnMainThread(Selector("mergeChangesFromContextDidSaveNotification:"), withObject: notification, waitUntilDone: false)
    }
    
    // Initialise a NSFetchRequest for a given entity
    class func requestForEntity(entity: WSEntity) -> NSFetchRequest {
        let request = NSFetchRequest(entityName: entity.rawValue)
        return request
    }
    
    // Excecutes a syncronous fetch request with the private context
    //
    class func executeFetchRequest(request: NSFetchRequest) throws -> [AnyObject] {
        
        var objects = [AnyObject]()
        var error: NSError?
        sharedStore.privateContext.performBlockAndWait { () -> Void in
            do {
                objects = try sharedStore.privateContext.executeFetchRequest(request)
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
    class func getAllFromEntity(entity: WSEntity) throws -> [AnyObject] {
        
        let request = requestForEntity(entity)
        
        do {
            let objects = try executeFetchRequest(request)
            return objects
        }
    }
    
    // Deletes all objects from the store
    //
    class func clearout() throws {
    
        // Cycle through entities and delete all entries
        let entities = WSEntity.allValues
        do {
            for entity in entities {
                let objects = try WSStore.getAllFromEntity(entity) as! [NSManagedObject]
                for object in objects {
                    sharedStore.privateContext.deleteObject(object)
                    try savePrivateContext()
                }
            }
        }
    }
    
    
    // MARK: Message thread handling methods
    
    // Returns all the message threads in the store
    //
    class func allMessageThreads() throws -> [CDWSMessageThread] {
        
        do {
            let threads = try getAllFromEntity(.Thread) as! [CDWSMessageThread]
            return threads
        }
    }
    
    // Checks if a message thread is already in the store by thread id.
    // Returns the existing message thread, or a new message thread inserted into the private context.
    //
    class func messageThreadWithID(threadID: Int) throws -> CDWSMessageThread? {
        
        let request = requestForEntity(.Thread)
        request.predicate = NSPredicate(format: "thread_id==%i", threadID)
        
        do {
            let thread = try executeFetchRequest(request).first as? CDWSMessageThread
            return thread
        }
    }
    
    // Checks if a message exists and returns it or a new one if it doesn't exist
    //
    class func newOrExistingMessageThread(threadID: Int) throws -> CDWSMessageThread {
        do {
            if let thread = try messageThreadWithID(threadID) {
                return thread
            } else {
                let thread = NSEntityDescription.insertNewObjectForEntityForName(WSEntity.Thread.rawValue, inManagedObjectContext: sharedStore.privateContext) as! CDWSMessageThread
                return thread
            }
        }
    }
    
    // Adds a message thread to the store with json
    //
    class func addMessageThread(json: AnyObject) throws {
        
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
    class func numberOfDownloadedMessagesOnThread(threadID: Int) throws -> Int {
        do {
            if let messageThread = try messageThreadWithID(threadID) {
                if let messages = messageThread.messages {
                    return messages.count
                }
            }
            return 0
        }
    }
    
    class func numberOfUnreadMessageThreads() throws -> Int {
        do {
            let threads = try allMessageThreads() as NSArray
            let isNew = threads.valueForKey("is_new") as! [Int]
            let sum = isNew.reduce(0, combine: +)
            return sum
        }
    }
    
    class func messageThreadsThatNeedUpdating() throws -> [Int] {
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
    
    class func allMessagesOnThread(threadID: Int) throws -> [CDWSMessage]? {
        do {
            var messages: [CDWSMessage]?
            if let messageThread = try messageThreadWithID(threadID) {
                messages = messageThread.messages?.allObjects as? [CDWSMessage]
            }
            return messages
        }
    }
    
    class func subjectForMessageThreadWithID(threadID: Int) -> String? {
        do {
            let messageThread = try messageThreadWithID(threadID)
            let subject = messageThread?.subject
            return subject
        } catch {
            return nil
        }
    }
    
    class func markMessageThread(threadID: Int, unread: Bool) throws {
        do {
            let messageThread = try messageThreadWithID(threadID)
            messageThread?.is_new = unread
            try savePrivateContext()
        }
    }
    
    
    // MARK: Message handling methods
    
    // Returns all the messages in the store
    //
    class func allMessages() throws -> [CDWSMessage] {
        
        do {
            let messages = try getAllFromEntity(.Message) as! [CDWSMessage]
            return messages
        }
    }
    
    // Checks if a message is already in the store by message id.
    // Returns the existing message, or a new message inserted into the private context.
    //
    class func messageWithID(messageID: Int) throws -> CDWSMessage? {
        
        let request = requestForEntity(.Message)
        request.predicate = NSPredicate(format: "message_id==%i", messageID)
        
        do {
            let message = try executeFetchRequest(request).first as? CDWSMessage
            return message
        }
    }
    
    // Checks if a message exists and returns it or a new one if it doesn't exist
    //
    class func newOrExistingMessage(messageID: Int) throws -> CDWSMessage {
        do {
            if let message = try messageWithID(messageID) {
                return message
            } else {
                let message = NSEntityDescription.insertNewObjectForEntityForName(WSEntity.Message.rawValue, inManagedObjectContext: sharedStore.privateContext) as! CDWSMessage
                return message
            }
        }
    }
    
    // Adds a message to the store with json
    //
    class func addMessage(json: AnyObject, onThreadWithID threadID: Int) throws {
        
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
    class func allUsers() throws -> [CDWSUser] {
        
        do {
            let users = try getAllFromEntity(.User) as! [CDWSUser]
            return users
        }
    }
    
    // Checks if a user is already in the store by uid.
    //
    class func userWithID(uid: Int) throws -> CDWSUser? {
        
        let request = requestForEntity(.User)
        request.predicate = NSPredicate(format: "uid == %i", uid)
        
        do {
            let user = try executeFetchRequest(request).first as? CDWSUser
            return user
        }
    }
    
    // Returns an existing user, or a new user inserted into the private context.
    //
    class func newOrExistingUser(uid: Int) throws -> CDWSUser {
        do {
            if let user = try userWithID(uid) {
                return user
            } else {
                let user = NSEntityDescription.insertNewObjectForEntityForName(WSEntity.User.rawValue, inManagedObjectContext: sharedStore.privateContext) as! CDWSUser
                return user
            }
        }
    }
    
    // Create a user set from json containing message thread participants
    //
    class func userSetFromJSON(json: AnyObject) throws -> NSSet {
        
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
    class func addUserWithParticipantJSON(json: AnyObject) throws {
    
        guard let fullname = json.valueForKey("fullname") as? String else {
            throw CDWSUserError.FailedValueForKey(key: "fullname")
        }
        
        guard let name = json.valueForKey("name") as? String else {
            throw CDWSUserError.FailedValueForKey(key: "name")
        }
        
        guard let uid = json.valueForKey("uid")?.integerValue else {
            throw CDWSUserError.FailedValueForKey(key: "uid")
        }
        
        do {
            let user = try newOrExistingUser(uid)
            user.fullname = fullname
            user.name = name
            user.uid = uid
            try savePrivateContext()
        }
    }
    
    // Adds a user to the store with json describing a host location
    //
    class func addUserToMapTile(mapTile: CDWSMapTile, withLocationJSON json: AnyObject) throws {
        
        guard let fullname = json.valueForKey("fullname") as? String else {
            throw CDWSUserError.FailedValueForKey(key: "fullname")
        }
        
        guard let name = json.valueForKey("name") as? String else {
            throw CDWSUserError.FailedValueForKey(key: "name")
        }
        
        guard let uid = json.valueForKey("uid")?.integerValue else {
            throw CDWSUserError.FailedValueForKey(key: "uid")
        }
        
        guard let latitude = json.valueForKey("latitude")?.doubleValue else {
            throw CDWSUserError.FailedValueForKey(key: "latitude")
        }
        
        guard let longitude = json.valueForKey("longitude")?.doubleValue else {
            throw CDWSUserError.FailedValueForKey(key: "longitude")
        }
        
        do {
            let user = try newOrExistingUser(uid)
            // Critical properties
            user.fullname = fullname
            user.name = name
            user.uid = uid
            user.latitude = latitude
            user.longitude = longitude
            // Other Properties
            user.additional = json.valueForKey("additional") as? String
            user.city = json.valueForKey("city") as? String
            user.country = json.valueForKey("country") as? String
            user.distance = json.valueForKey("distance")?.doubleValue
            user.notcurrentlyavailable = json.valueForKey("notcurrentlyavailable")?.boolValue
            user.post_code = json.valueForKey("postal_code") as? String
            user.province = json.valueForKey("province") as? String
            user.image_url = json.valueForKey("profile_image_map_infoWindow") as? String
            user.street = json.valueForKey("street") as? String
            user.map_tile = mapTile
        }
    }
    
    // Updates a users profile thumbnail image url
    class func updateUserImageURLWithJSON(json: AnyObject) throws {
        
        guard let uid = json.valueForKey("uid")?.integerValue else {
            throw DataError.InvalidInput
        }
        
        do {
            if let user = try userWithID(uid) {
                user.image_url = json.valueForKey("profile_image_map_infoWindow") as? String
                try savePrivateContext()
            } else {
                let error = NSError(domain: "WSStore", code: 1, userInfo: [NSLocalizedDescriptionKey : "Can not update image url for user. User is not in the store."])
                throw error
            }
        }
    }
    
    // Update a user with a thumbnail image 
    class func updateUser(uid: Int, withImage image: UIImage) throws {
        
        do {
            if let user = try userWithID(uid) {
                user.image = image
                try savePrivateContext()
            } else {
                let error = NSError(domain: "WSStore", code: 2, userInfo: [NSLocalizedDescriptionKey : "Can not update image for user. User is not in the store."])
                throw error
            }
        }
    }
    
    // MARK: Map Tile handling methods
    
    // Returns all the map tiles in the store
    //
    class func allMapTiles() throws -> [CDWSMapTile] {
        
        do {
            let tiles = try getAllFromEntity(.MapTile) as! [CDWSMapTile]
            return tiles
        }
    }
    
    // Checks if a map tile is already in the store.
    //
    class func mapTileAtPosition(x: UInt, y: UInt, z: UInt) throws -> CDWSMapTile? {
        
        let request = requestForEntity(.MapTile)
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "x == %i", x))
        predicates.append(NSPredicate(format: "y == %i", y))
        predicates.append(NSPredicate(format: "z == %i", z))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        do {
            let tile = try executeFetchRequest(request).first as? CDWSMapTile
            return tile
        }
    }
    
    // Returns a map tile by its identifer
    class func mapTileWithID(id: String) throws -> CDWSMapTile? {
        
        let request = requestForEntity(.MapTile)
        request.predicate = NSPredicate(format: "%K == %@", "identifier", id)
        
        do {
            let tile = try executeFetchRequest(request).first as? CDWSMapTile
            return tile
        }
    }
    
    // Returns an existing map tile, or a new map tile into the private context.
    //
    class func newOrExistingMapTileAtPosition(x: UInt, y: UInt, z: UInt) throws -> CDWSMapTile {
        do {
            if let tile = try mapTileAtPosition(x, y: y, z: z) {
                return tile
            } else {
                let tile = NSEntityDescription.insertNewObjectForEntityForName(WSEntity.MapTile.rawValue, inManagedObjectContext: sharedStore.privateContext) as! CDWSMapTile
                tile.x = x
                tile.y = y
                tile.z = z
                tile.identifier = tile.identifierFromXYZ
                return tile
            }
        }
    }
    
    // Removes tiles from the data base that haven't been loaded in a while
    class func clearoutOldTiles() {
        do {
            let tiles = try allMapTiles()
            for tile in tiles {
                if let last_updated = tile.last_updated {
                    if abs(last_updated.timeIntervalSinceNow) > MapTileExpiryTime {
                        print("deleting tile")
                        sharedStore.privateContext.deleteObject(tile)
                    }
                }
            }
        } catch {
            print("Error clearing out old tiles")
        }
    }
    
}

