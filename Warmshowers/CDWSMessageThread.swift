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
    
    // Returns true if the message count doesn't match the number of messages relationships
    //
    func needsUpdating() -> Bool {
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
        
        let results = participants.filter { (user) -> Bool in
            let user = user as! CDWSUser
            return user.uid == uid
        }
        if results.count > 0 {
            let user = results.first as? CDWSUser
            return user
        } else {
            return nil
        }
    }

}
