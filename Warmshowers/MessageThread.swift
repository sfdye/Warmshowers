//
//  MessageThread.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 2/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

enum MessageThreadError : ErrorType {
    case FailedValueForKey(key: String)
}

class MessageThread: NSManagedObject {

    // Updates all fields of the message thread with JSON data
    //
    func updateWithJSON(json: AnyObject, AndParticipantSet participants: NSSet) throws {
        
        guard let count = json.valueForKey("count")?.integerValue else {
            throw MessageThreadError.FailedValueForKey(key: "count")
        }

        guard let has_tokens = json.valueForKey("has_tokens")?.integerValue else {
            throw MessageThreadError.FailedValueForKey(key: "has_tokens")
        }
        
        guard let is_new = json.valueForKey("is_new")?.integerValue else {
            throw MessageThreadError.FailedValueForKey(key: "is_new")
        }
        
        guard let last_updated = json.valueForKey("last_updated")?.integerValue else {
            throw MessageThreadError.FailedValueForKey(key: "last_updated")
        }
        
        guard let subject = json.valueForKey("subject") as? String else {
            throw MessageThreadError.FailedValueForKey(key: "subject")
        }
        
        guard let thread_id = json.valueForKey("thread_id")?.integerValue else {
            throw MessageThreadError.FailedValueForKey(key: "thread_id")
        }
        
        guard let thread_started = json.valueForKey("thread_started")?.integerValue else {
            throw MessageThreadError.FailedValueForKey(key: "thread_started")
        }
        
        self.count = count
        self.has_tokens = has_tokens
        self.is_new = is_new
        self.last_updated = last_updated
        self.subject = subject
        self.thread_id = thread_id
        self.thread_started = thread_started
        self.participants = participants
        
    }
    
    // Returns a string of the message thread participant names
    //
    func getParticipantString(currentUserUID: Int?) -> String {
        
        guard let users = participants?.allObjects else {
            return ""
        }
        
        var pString = ""
        for user in users {
            if let participant = user as? User {
                
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

}
