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
    
    func messageWithID(_ messageID: Int) throws -> CDWSMessage? {
        
        let request = requestForEntity(.Message)
        request.predicate = Predicate(format: "message_id==%i", messageID)
        
        do {
            let message = try executeFetchRequest(request).first as? CDWSMessage
            return message
        }
    }
    
    func newOrExistingMessage(_ messageID: Int) throws -> CDWSMessage {
        do {
            if let message = try messageWithID(messageID) {
                return message
            } else {
                let message = NSEntityDescription.insertNewObject(forEntityName: WSEntity.Message.rawValue, into: privateContext) as! CDWSMessage
                return message
            }
        }
    }
    
    func addMessage(_ json: AnyObject, onThreadWithID threadID: Int) throws {
        
        // JSON input checks
        guard let body = json.value(forKey: "body") as? String else {
            throw CDWSMessageThreadError.failedValueForKey(key: "count")
        }
        
        guard let message_id = json.value(forKey: "mid")?.intValue else {
            throw CDWSMessageThreadError.failedValueForKey(key: "mid")
        }
        
        guard let timestamp = json.value(forKey: "timestamp")?.doubleValue else {
            throw CDWSMessageThreadError.failedValueForKey(key: "timestamp")
        }
        
        guard let is_new = json.value(forKey: "is_new")?.boolValue else {
            throw CDWSMessageThreadError.failedValueForKey(key: "is_new")
        }
        
        guard let author_uid = json.value(forKey: "author")?.intValue else {
            throw CDWSMessageThreadError.failedValueForKey(key: "author")
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
            message.timestamp = Date(timeIntervalSince1970: timestamp)
            message.is_new = is_new
            try savePrivateContext()
        }
    }
}
