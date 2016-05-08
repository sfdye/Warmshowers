//
//  WSStore+Messages.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

extension WSStore : WSStoreMessageProtocol {
    
    func allMessages() throws -> [CDWSMessage] {
        do {
            let messages = try getAllEntriesFromEntity(.Message) as! [CDWSMessage]
            return messages
        }
    }
    
    func messageWithID(messageID: Int) throws -> CDWSMessage? {
        
        let request = requestForEntity(.Message)
        request.predicate = NSPredicate(format: "message_id==%i", messageID)
        
        do {
            let message = try executeFetchRequest(request).first as? CDWSMessage
            return message
        }
    }
    
    func newOrExistingMessage(messageID: Int) throws -> CDWSMessage {
        do {
            if let message = try messageWithID(messageID) {
                return message
            } else {
                let message = NSEntityDescription.insertNewObjectForEntityForName(WSEntity.Message.rawValue, inManagedObjectContext: privateContext) as! CDWSMessage
                return message
            }
        }
    }
    
    func addMessage(json: AnyObject, onThreadWithID threadID: Int) throws {
        
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
            let author = try newOrExistingParticipant(author_uid)
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
}