//
//  CDWSMessageThread.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 4/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

enum CDWSMessageThreadError : ErrorProtocol {
    case failedValueForKey(key: String)
    case threadWithIDNotFound(id: Int)
}

class CDWSMessageThread: NSManagedObject {

    // MARK: Instance methods
    
    // Returns a string of the message thread participant names
    //
    func getParticipantString(_ currentUserUID: Int?) -> String {
        
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
    
    // Returns the message thread participants with the currently logged-in user removed
    func otherParticipants(_ currentUserUID: Int) -> [CDWSUser] {
        
        guard var users = participants?.allObjects as? [CDWSUser] else {
            return [CDWSUser]()
        }
        
        var index: Int?
        for (i, user) in users.enumerated() {
            if user.uid == currentUserUID {
                index = i
            }
        }
        if let index = index {
            users.remove(at: index)
        }
        
        return users
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
        messages.sort {
            return ($0.timestamp!.laterDate($1.timestamp! as Date) == $0.timestamp! as Date)
        }
        
        return messages.first
    }
    
    // Returns a string of the lastest message body
    //
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
