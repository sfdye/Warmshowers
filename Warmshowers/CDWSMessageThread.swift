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
}

class CDWSMessageThread: NSManagedObject {
    
    static let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // MARK: Instance methods

    // Updates all fields of the message thread with JSON data
    //
    func updateWithJSON(json: AnyObject) throws {
        
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
        
        self.count = count
        self.has_tokens = has_tokens
        self.is_new = is_new
        self.last_updated = NSDate(timeIntervalSince1970: last_updated)
        self.subject = subject
        self.thread_id = thread_id
        self.thread_started = NSDate(timeIntervalSince1970: thread_started)
        
        // Don't need change the message participants if they already exist
        guard let participants = participants where participants.count == 0 else {
            return
        }
        
        guard let participantsJSON = json.valueForKey("participants") else {
            throw DataError.InvalidInput
        }
        
        do {
            let participants = try CDWSUser.userSetFromJSON(participantsJSON)
            self.participants = participants
        }
    }
    
    // Returns a string of the message thread participant names
    //
    func getParticipantString(currentUserUID: Int?) -> String {
        
        guard let users = participants?.allObjects else {
            return ""
        }
        
        var pString = ""
        for user in users {
            if let participant = user as? CDWSUser {
                
                // Omit the current user from the participants string
                if currentUserUID != nil && participant.uid == currentUserUID {
                    continue
                }
                
                if pString != "" {
                    pString += ", "
                }
                if let name = participant.fullname {
                    pString += name
                }
                
            } else {
                print("Cast error")
            }
        }
        
        return pString
    }
    
    // Returns true if:
    // a. the message count doesn't match the number of messages relationships
    // b. the last updated date doesn't match the record in the store (when json is provided)
    //
    func needsUpdating(json: AnyObject? = nil) -> Bool {
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
    
    // Returns a thread participant with the uid or nil if the user is not a participant
    func participantWithUID(uid: Int) -> CDWSUser? {
        
        guard let participants = participants where participants.count > 0 else {
            return nil
        }
        
        let predicate = NSPredicate(format: "uid == %i", uid)
        if let user = participants.filteredSetUsingPredicate(predicate).first as? CDWSUser {
            return user
        } else {
            return nil
        }
    }
    
    
    // MARK: Type methods
    
    static func allMessageThreads() throws -> [CDWSMessageThread] {
        let request = NSFetchRequest(entityName: "MessageThread")
        do {
            let threads = try moc.executeFetchRequest(request) as! [CDWSMessageThread]
            return threads
        }
    }
    
    static func messageThreadWithID(threadID: Int?) -> CDWSMessageThread? {
        
        guard let threadID = threadID else {
            return nil
        }
        
        let request = NSFetchRequest(entityName: "MessageThread")
        request.predicate = NSPredicate(format: "thread_id==%i", threadID)
        do {
            let thread = try moc.executeFetchRequest(request).first as? CDWSMessageThread
            return thread
        } catch {
            return nil
        }
    }
    
    static func newOrExistingMessageThread(threadID: Int) -> CDWSMessageThread {
        if let messageThread = messageThreadWithID(threadID) {
            return messageThread
        } else {
            let messageThread = NSEntityDescription.insertNewObjectForEntityForName("MessageThread", inManagedObjectContext: moc) as! CDWSMessageThread
            return messageThread
        }
    }
    
    static func messageThreadAtIndexPath(indexPath: NSIndexPath) -> CDWSMessageThread? {
        let request = NSFetchRequest(entityName: "MessageThread")
        request.sortDescriptors = [NSSortDescriptor(key: "last_updated", ascending: false)]
        do {
            let threads = try moc.executeFetchRequest(request) as! [CDWSMessageThread]
            
            guard threads.count > indexPath.row else {
                return nil
            }
            
            return threads[indexPath.row]
            
        } catch {
            return nil
        }
    }
    
    static func messageAtIndexPath(indexPath: NSIndexPath, onMessageThreadWithID threadID: Int?) -> CDWSMessage? {
        
        guard let messageThread = CDWSMessageThread.messageThreadWithID(threadID) else {
            return nil
        }
        
        if let messages = messageThread.messages?.sortedArrayUsingDescriptors([NSSortDescriptor(key: "timestamp", ascending: false)]) as? [CDWSMessage] {
            let message = messages[indexPath.row]
            return message
        } else {
            return nil
        }
    }
    
    static func subjectForMessageThread(threadID: Int?) -> String? {
        if let messageThread = CDWSMessageThread.messageThreadWithID(threadID) {
            return messageThread.subject
        } else {
            return nil
        }
    }
    
    static func numberOfMessageThreads() -> Int {
        do {
            let threads = try CDWSMessageThread.allMessageThreads()
            return threads.count
        } catch let error {
            return 0
        }
    }
    
    static func numberOfMessagesOnThread(threadID: Int?) -> Int {
        if let messageThread = CDWSMessageThread.messageThreadWithID(threadID) {
            if let messages = messageThread.messages {
                return messages.count
            }
        }
        return 0
    }
    
    static func numberOfUnreadMessageThreads() -> Int {
        do {
            let threads = try CDWSMessageThread.allMessageThreads() as NSArray
            let isNew = threads.valueForKey("is_new") as! [Int]
            let sum = isNew.reduce(0, combine: +)
            return sum
        } catch {
            return 0
        }
    }

}
