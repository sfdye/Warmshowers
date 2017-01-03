//
//  MOMessageThread.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 31/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

public class MOMessageThread: NSManagedObject, Fetchable, JSONUpdateable {
    
    // MARK: Fetchable
    
    public static var entityName: String { return "MessageThread" }
    
    // MARK: Getters and setters
    
    public var count: Int? {
        get { return p_count?.intValue }
        set(new) { p_count = new == nil ? nil : NSNumber(value: new!) }
    }
    
    public var has_tokens: Bool {
        get { return p_has_tokens?.boolValue ?? false }
        set(new) { p_has_tokens = NSNumber(value: new) }
    }
    
    public var is_new: Bool {
        get { return p_is_new?.boolValue ?? false }
        set(new) { p_is_new = NSNumber(value: new) }
    }
    
    public var thread_id: Int? {
        get { return p_thread_id?.intValue }
        set(new) { p_thread_id = new == nil ? nil : NSNumber(value: new!) }
    }
    
    // MARK: JSONUpdateable
    
    static func predicate(fromJSON json: Any, withParser parser: JSONParser) throws -> NSPredicate {
        do {
            let threadID = try parser.nonOptional(forKey:"thread_id", fromJSON: json, withType: Int.self)
            return NSPredicate(format: "p_thread_id == %d", threadID)
        }
    }
    
    func update(withJSON json: Any, withParser parser: JSONParser) throws {
        
        guard let json = json as? [String: AnyObject] else {
            throw MOUpdateError.castingError
        }
        
        do {
            count = parser.optional(forKey: "count", fromJSON: json as AnyObject, withType: Int.self)
            has_tokens = try parser.nonOptional(forKey:"has_tokens", fromJSON: json, withType: Bool.self)
            is_new = try parser.nonOptional(forKey:"is_new", fromJSON: json, withType: Bool.self)
            last_updated = try parser.nonOptional(forKey:"last_updated", fromJSON: json as AnyObject, withType: Date.self)
            subject = parser.optional(forKey: "subject", fromJSON: json as AnyObject, withType: String.self)
            thread_id = try parser.nonOptional(forKey:"thread_id", fromJSON: json as AnyObject, withType: Int.self)
            thread_started = parser.optional(forKey: "thread_started", fromJSON: json as AnyObject, withType: Date.self)
        }
    }

    // MARK: Instance methods
    
    /** Returns a string of the message thread participant names. */
    public func participantString(withCurrentUserUID currentUserUID: Int?) -> String {
        
        guard let users = participants?.allObjects as? [MOUser] else {
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
    public func namesOfParticipants(excludingUserWithUID uid: Int) -> [String] {
        
        guard let users = participants?.allObjects as? [MOUser] else {
            return [String]()
        }
        
        let otherParticipants = users.filter { (user) -> Bool in
            return user.uid != uid && user.name != nil
        }
        
        let names: [String] = otherParticipants.map { (user) -> String in
            user.name ?? ""
        }

        return names
    }
    
    /** Returns true if the message count doesn't match the number of messages relationships. */
    public func needsUpdating() -> Bool {
        return count != messages!.count
    }
    
    /** Returns the lastest message or nil if there are no messages. */
    func lastestMessage() -> MOMessage? {
        
        guard var messages = self.messages?.allObjects as? [MOMessage] , messages.count > 0 else {
            return nil
        }
        
        // Sort the messages to latest first
        messages.sort {
            return $0.timestamp! > $1.timestamp!
        }
        
        return messages.first
    }
    
    /** Returns a string of the lastest message body. */
    public func lastestMessagePreview() -> String? {
        
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
