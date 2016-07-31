//
//  WSMOMessageThread.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 31/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData


class WSMOMessageThread: NSManagedObject, JSONUpdateable {
    
    // MARK: Getters and setters
    
    var count: Int? {
        get { return p_count?.integerValue }
        set(new) { p_count = new == nil ? nil : NSNumber(integer: new!) }
    }
    
    var has_tokens: Bool {
        get { return p_has_tokens?.boolValue ?? false }
        set(new) { p_has_tokens = NSNumber(bool: new) }
    }
    
    var is_new: Bool {
        get { return p_is_new?.boolValue ?? false }
        set(new) { p_is_new = NSNumber(bool: new) }
    }
    
    var thread_id: Int? {
        get { return p_thread_id?.integerValue }
        set(new) { p_thread_id = new == nil ? nil : NSNumber(integer: new!) }
    }
    
    
    // MARK: JSONUpdateable
    
    static var entityName: String { return "MessageThread" }
    
    static func predicateFromJSON(json: AnyObject) throws -> NSPredicate {
        do {
            let threadID = try JSON.nonOptionalForKey("thread_id", fromDict: json, withType: Int.self)
            return NSPredicate(format: "p_thread_id == %d", threadID)
        }
    }
    
    func update(json: AnyObject) throws {
        
        guard let json = json as? [String: AnyObject] else {
            throw WSMOUpdateError.CastingError
        }
        
        do {
            count = JSON.optionalForKey("count", fromDict: json, withType: Int.self)
            has_tokens = try JSON.nonOptionalForKey("has_tokens", fromDict: json, withType: Bool.self)
            is_new = try JSON.nonOptionalForKey("is_new", fromDict: json, withType: Bool.self)
            last_updated = try JSON.nonOptionalForKey("last_updated", fromDict: json, withType: NSDate.self)
            subject = JSON.optionalForKey("subject", fromDict: json, withType: String.self)
            thread_id = try JSON.nonOptionalForKey("thread_id", fromDict: json, withType: Int.self)
            thread_started = JSON.optionalForKey("thread_started", fromDict: json, withType: NSDate.self)
        }
    }

    // MARK: Instance methods
    
    /** Returns a string of the message thread participant names. */
    func getParticipantString(currentUserUID: Int?) -> String {
        
        guard let users = participants?.allObjects as? [WSMOUser] else {
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
    
    /** Returns the message thread participants with the currently logged-in user removed. */
    func otherParticipants(currentUserUID: Int) -> [WSMOUser] {
        
        guard var users = participants?.allObjects as? [WSMOUser] else {
            return [WSMOUser]()
        }
        
        var index: Int?
        for (i, user) in users.enumerate() {
            if user.uid == currentUserUID {
                index = i
            }
        }
        if let index = index {
            users.removeAtIndex(index)
        }
        
        return users
    }
    
    /** Returns true if the message count doesn't match the number of messages relationships. */
    func needsUpdating() -> Bool {
        return count != messages!.count
    }
    
    /** Returns the lastest message or nil if there are no messages. */
    func lastestMessage() -> WSMOMessage? {
        
        guard var messages = self.messages?.allObjects as? [WSMOMessage] where messages.count > 0 else {
            return nil
        }
        
        // Sort the messages to latest first
        messages.sortInPlace {
            return $0.timestamp!.laterDate($1.timestamp!).isEqualToDate($0.timestamp!)
        }
        
        return messages.first
    }
    
    /** Returns a string of the lastest message body. */
    func lastestMessagePreview() -> String? {
        
        if let latestMessage =  self.lastestMessage() {
            if var preview = latestMessage.body {
                preview += "\n"
                // TODO remove blank lines from the message body so the preview doens't display blanks
                return preview
            }
        }
        return nil
    }

}
