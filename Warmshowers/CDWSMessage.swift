//
//  CDWSMessage.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 4/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

enum CDWSMessageError : ErrorType {
    case FailedValueForKey(key: String)
}

class CDWSMessage: NSManagedObject {
    
    static let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var authorName: String? {
        if let author = self.author {
            return author.fullname
        } else {
            return nil
        }
    }
    
    var authorThumbnail: UIImage? {
        if let author = self.author {
            return author.image as? UIImage
        } else {
            return nil
        }
    }
    
    // Updates all fields of the message thread with JSON data
    //
    func updateWithJSON(json: AnyObject) throws {
        
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
        
        self.body = body
        self.message_id = message_id
        self.timestamp = NSDate(timeIntervalSince1970: timestamp)
        self.is_new = is_new
        
        // Don't need change the author if one already exist
        guard author == nil else {
            print("alreay got author")
            return
        }
        
        guard let author = json.valueForKey("author")?.integerValue else {
            throw CDWSMessageThreadError.FailedValueForKey(key: "author")
        }
        
        let user = CDWSUser.newOrExistingUser(author)
        self.author = user
    }
    
    static func allMessages() throws -> [CDWSMessage] {
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "Message")
        do {
            let threads = try moc.executeFetchRequest(request) as! [CDWSMessage]
            return threads
        }
    }
    
    static func messageWithID(messageID: Int?) -> CDWSMessage? {
        
        guard let messageID = messageID else {
            return nil
        }
        
        let request = NSFetchRequest(entityName: "Message")
        request.predicate = NSPredicate(format: "message_id==%i", messageID)
        do {
            let thread = try moc.executeFetchRequest(request).first as? CDWSMessage
            return thread
        } catch {
            return nil
        }
    }
    
    static func newOrExistingMessage(messageID: Int) -> CDWSMessage {
        if let message = messageWithID(messageID) {
            return message
        } else {
            let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: moc) as! CDWSMessage
            return message
        }
    }

}
