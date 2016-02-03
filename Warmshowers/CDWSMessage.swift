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
    
//    static let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
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
    
//    // Updates all fields of the message thread with JSON data
//    //
//    func updateWithJSON(json: AnyObject, withMessageStore store: WSMessageStore) throws {
//        
//        guard let body = json.valueForKey("body") as? String else {
//            throw CDWSMessageThreadError.FailedValueForKey(key: "count")
//        }
//        
//        guard let message_id = json.valueForKey("mid")?.integerValue else {
//            throw CDWSMessageThreadError.FailedValueForKey(key: "mid")
//        }
//        
//        guard let timestamp = json.valueForKey("timestamp")?.doubleValue else {
//            throw CDWSMessageThreadError.FailedValueForKey(key: "timestamp")
//        }
//        
//        guard let is_new = json.valueForKey("is_new")?.boolValue else {
//            throw CDWSMessageThreadError.FailedValueForKey(key: "is_new")
//        }
//        
//        self.body = body
//        self.message_id = message_id
//        self.timestamp = NSDate(timeIntervalSince1970: timestamp)
//        self.is_new = is_new
//        
//        guard let author = json.valueForKey("author")?.integerValue else {
//            throw CDWSMessageThreadError.FailedValueForKey(key: "author")
//        }
//        
//        
//        do {
//            let user = try store.newOrExistingUser(author)
//        self.author = user
//    }
    
//    static func allMessagesInContext(context: NSManagedObjectContext = moc) throws -> [CDWSMessage] {
//
//        let request = NSFetchRequest(entityName: "Message")
//        
//        var messages = [CDWSMessage]()
//        context.performBlockAndWait { () -> Void in
//            do {
//                messages = try context.executeFetchRequest(request) as! [CDWSMessage]
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
//        }
//        return messages
//    }
//    
//    static func messageWithID(messageID: Int?, inContext context: NSManagedObjectContext = moc) -> CDWSMessage? {
//        
//        guard let messageID = messageID else {
//            return nil
//        }
//        
//        let request = NSFetchRequest(entityName: "Message")
//        request.predicate = NSPredicate(format: "message_id==%i", messageID)
//        
//        var message: CDWSMessage?
//        context.performBlockAndWait { () -> Void in
//            do {
//                message = try moc.executeFetchRequest(request).first as? CDWSMessage
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
//        }
//        return message
//    }
//    
//    static func newOrExistingMessage(messageID: Int, inContext context: NSManagedObjectContext = moc) -> CDWSMessage {
//        if let message = messageWithID(messageID, inContext: context) {
//            return message
//        } else {
//            let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as! CDWSMessage
//            return message
//        }
//    }

}
