//
//  CDWSMessageThread.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 4/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

enum CDWSMessageThreadError : ErrorType {
    case FailedValueForKey(key: String)
    case ThreadWithIDNotFound(id: Int)
}

class CDWSMessageThread: NSManagedObject {
    
//    static let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//    static var privateContext: NSManagedObjectContext {
//        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
//        privateContext.persistentStoreCoordinator = moc.persistentStoreCoordinator
//        return privateContext
//    }

    
    // MARK: Instance methods
    
    // Returns a string of the message thread participant names
    //
    func getParticipantString(currentUserUID: Int?) -> String {
        
        guard let users = participants?.allObjects as? [CDWSUser] else {
            return ""
        }
        
        var pString = ""
        for user in users {
            // Omit the current user from the participants string
            if currentUserUID != nil && user.uid == currentUserUID {
                continue
            }
            
            if pString != "" {
                pString += ", "
            }
            
            if let name = user.fullname {
                pString += name
            }
        }
        
        return pString
    }
    
    // Returns true if the message count doesn't match the number of messages relationships
    //
    func needsUpdating() -> Bool {
        if (count != messages!.count) {
            print("MESSAGE THREAD: needs updating")
        }
        
        return count != messages!.count
    }
    
    // Returns the lastest message or nil if there are no messages
    //
    func lastestMessage() -> CDWSMessage? {
        
        guard var messages = self.messages?.allObjects as? [CDWSMessage] where messages.count > 0 else {
            return nil
        }
        
        // Sort the messages to latest first
        messages.sortInPlace {
            return $0.timestamp!.laterDate($1.timestamp!).isEqualToDate($0.timestamp!)
        }
        
        return messages.first
    }
    
    // Returns a string of the lastest message body
    //
    func lastestMessagePreview() -> String {
        
        if let latest =  self.lastestMessage() {
            if var preview = latest.body {
                preview += "\n"
                // TODO remove blank lines from the message body so the preview doens't display blanks
                return preview
            }
        }
        return ""
    }

}

//    // Updates all fields of the message thread with JSON data
//    //
//    func updateWithJSON(json: AnyObject) throws {
//
//        guard let count = json.valueForKey("count")?.integerValue else {
//            throw CDWSMessageThreadError.FailedValueForKey(key: "count")
//        }
//
//        guard let has_tokens = json.valueForKey("has_tokens")?.integerValue else {
//            throw CDWSMessageThreadError.FailedValueForKey(key: "has_tokens")
//        }
//
//        guard let is_new = json.valueForKey("is_new")?.integerValue else {
//            throw CDWSMessageThreadError.FailedValueForKey(key: "is_new")
//        }
//
//        guard let last_updated = json.valueForKey("last_updated")?.doubleValue else {
//            throw CDWSMessageThreadError.FailedValueForKey(key: "last_updated")
//        }
//
//        guard let subject = json.valueForKey("subject") as? String else {
//            throw CDWSMessageThreadError.FailedValueForKey(key: "subject")
//        }
//
//        guard let thread_id = json.valueForKey("thread_id")?.integerValue else {
//            throw CDWSMessageThreadError.FailedValueForKey(key: "thread_id")
//        }
//
//        guard let thread_started = json.valueForKey("thread_started")?.doubleValue else {
//            throw CDWSMessageThreadError.FailedValueForKey(key: "thread_started")
//        }
//
//        self.count = count
//        self.has_tokens = has_tokens
//        self.is_new = is_new
//        self.last_updated = NSDate(timeIntervalSince1970: last_updated)
//        self.subject = subject
//        self.thread_id = thread_id
//        self.thread_started = NSDate(timeIntervalSince1970: thread_started)
//
//        // Don't need change the message participants if they already exist
//        guard let participants = participants where participants.count == 0 else {
//            return
//        }
//
//        guard let participantsJSON = json.valueForKey("participants") else {
//            throw DataError.InvalidInput
//        }
//
//        do {
//            let participants = try CDWSUser.userSetFromJSON(participantsJSON)
//            self.participants = participants
//        }
//    }
    
//    // Returns a thread participant with the uid or nil if the user is not a participant
//    func participantWithUID(uid: Int) -> CDWSUser? {
//        
//        guard let participants = participants where participants.count > 0 else {
//            return nil
//        }
//        
//        let predicate = NSPredicate(format: "uid == %i", uid)
//        if let user = participants.filteredSetUsingPredicate(predicate).first as? CDWSUser {
//            return user
//        } else {
//            return nil
//        }
//    }
    
    
    // MARK: Type methods
    
//    static func allMessageThreadsInContext(context:NSManagedObjectContext = moc) throws -> [CDWSMessageThread] {
//        
//        let request = NSFetchRequest(entityName: "MessageThread")
//        
//        var threads = [CDWSMessageThread]()
//        context.performBlockAndWait { () -> Void in
//            do {
//                threads = try context.executeFetchRequest(request) as! [CDWSMessageThread]
//            } catch {
//                print("error fetching")
//            }
//        }
//        return threads
    
//        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
//        privateContext.persistentStoreCoordinator = moc.persistentStoreCoordinator
//        
//        do {
//            if let threads = try privateContext.executeFetchRequest(request) as? [CDWSMessageThread] {
//                return threads
//            } else {
//                return [CDWSMessageThread]()
//            }
//        }
//    }
    
//    static func messageThreadWithID(threadID: Int?, inContext context:NSManagedObjectContext = moc) -> CDWSMessageThread? {
//        
//        guard let threadID = threadID else {
//            return nil
//        }
//        
//        let request = NSFetchRequest(entityName: "MessageThread")
//        request.predicate = NSPredicate(format: "thread_id==%i", threadID)

//        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//        let privateMOC = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
//        privateMOC.parentContext = moc
        
//        do {
//            let thread = try moc.executeFetchRequest(request).first as? CDWSMessageThread
//            return thread
//        } catch {
//            print("error fetching")
//            return nil
//        }
        
//        var thread: CDWSMessageThread?
//        context.performBlockAndWait { () -> Void in
//            do {
//                thread = try context.executeFetchRequest(request).first as? CDWSMessageThread
//            } catch {
//                print("error fetching")
//            }
//        }
//        print("\(thread)")
//        return thread
    
        
//        var thread: CDWSMessageThread?
//        do {
//            thread = try WSPrivateContext.fetchObject(request) as? CDWSMessageThread
//            return thread
//        } catch let error as NSError {
//            print(error.localizedDescription)
//            return nil
//        }
//    }

//    static func newOrExistingMessageThread(threadID: Int, inContext context:NSManagedObjectContext = moc) -> CDWSMessageThread {
//        if let messageThread = messageThreadWithID(threadID, inContext: context) {
//            return messageThread
//        } else {
//            let messageThread = NSEntityDescription.insertNewObjectForEntityForName("MessageThread", inManagedObjectContext: context) as! CDWSMessageThread
//            return messageThread
//        }
//    }

//    static func subjectForMessageThread(threadID: Int?) -> String? {
//        if let messageThread = CDWSMessageThread.messageThreadWithID(threadID) {
//            return messageThread.subject
//        } else {
//            return nil
//        }
//    }

//    static func numberOfMessageThreads() throws -> Int {
//        do {
//            let threads = try CDWSMessageThread.allMessageThreadsInContext()
//            return threads.count
//        }
//    }
    
//    static func numberOfDownloadedMessagesOnThread(threadID: Int?) -> Int {
//        if let messageThread = CDWSMessageThread.messageThreadWithID(threadID) {
//            if let messages = messageThread.messages {
//                return messages.count
//            }
//        }
//        return 0
//    }
//
//    static func numberOfUnreadMessageThreads() -> Int {
//        do {
//            let threads = try CDWSMessageThread.allMessageThreadsInContext() as NSArray
//            let isNew = threads.valueForKey("is_new") as! [Int]
//            let sum = isNew.reduce(0, combine: +)
//            return sum
//        } catch {
//            return 0
//        }
//    }
//    
//    static func messageThreadsThatNeedUpdating() throws -> [Int]? {
//        do {
//            var threadIDs = [Int]()
//            let threads = try CDWSMessageThread.allMessageThreadsInContext()
//            for thread in threads {
//                if thread.needsUpdating() {
//                    if let threadID = thread.thread_id?.integerValue {
//                        threadIDs.append(threadID)
//                    }
//                }
//            }
//            if threadIDs.count > 0 {
//                return threadIDs
//            } else {
//                return nil
//            }
//        }
//    }
//    
//    static func allMessagesOnThread(threadID: Int) -> [CDWSMessage]? {
//        if let messageThread = CDWSMessageThread.messageThreadWithID(threadID) {
//            let messages = messageThread.messages?.allObjects as! [CDWSMessage]
//            return messages
//        } else {
//            return nil
//        }
//    }
//
//}
