//
//  WSStore+MessageThreads.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

extension WSStore : WSStoreMessageThreadProtocol {
    
    func allMessageThreads() throws -> [CDWSMessageThread] {
        do {
            let threads = try getAllEntriesFromEntity(.Thread) as! [CDWSMessageThread]
            return threads
        }
    }
    
    func messageThreadWithID(_ threadID: Int) throws -> CDWSMessageThread? {
        let request = requestForEntity(.Thread)
        request.predicate = Predicate(format: "thread_id==%i", threadID)
        
        do {
            let thread = try executeFetchRequest(request).first as? CDWSMessageThread
            return thread
        }
    }
    
    func newOrExistingMessageThread(_ threadID: Int) throws -> CDWSMessageThread {
        do {
            if let thread = try messageThreadWithID(threadID) {
                return thread
            } else {
                let thread = NSEntityDescription.insertNewObject(forEntityName: WSEntity.Thread.rawValue, into: privateContext) as! CDWSMessageThread
                return thread
            }
        }
    }
    
    func addMessageThread(_ json: AnyObject) throws {
        
        guard let count = json.value(forKey: "count")?.intValue else {
            throw CDWSMessageThreadError.failedValueForKey(key: "count")
        }
        
        guard let has_tokens = json.value(forKey: "has_tokens")?.intValue else {
            throw CDWSMessageThreadError.failedValueForKey(key: "has_tokens")
        }
        
        guard let is_new = json.value(forKey: "is_new")?.intValue else {
            throw CDWSMessageThreadError.failedValueForKey(key: "is_new")
        }
        
        guard let last_updated = json.value(forKey: "last_updated")?.doubleValue else {
            throw CDWSMessageThreadError.failedValueForKey(key: "last_updated")
        }
        
        guard let subject = json.value(forKey: "subject") as? String else {
            throw CDWSMessageThreadError.failedValueForKey(key: "subject")
        }
        
        guard let thread_id = json.value(forKey: "thread_id")?.intValue else {
            throw CDWSMessageThreadError.failedValueForKey(key: "thread_id")
        }
        
        guard let thread_started = json.value(forKey: "thread_started")?.doubleValue else {
            throw CDWSMessageThreadError.failedValueForKey(key: "thread_started")
        }
        
        // Get the message participants, then save the message
        do {
            let thread = try newOrExistingMessageThread(thread_id)
            thread.count = count
            thread.has_tokens = has_tokens
            thread.is_new = is_new
            thread.last_updated = Date(timeIntervalSince1970: last_updated)
            thread.subject = subject
            thread.thread_id = thread_id
            thread.thread_started = Date(timeIntervalSince1970: thread_started)
            
            // Don't need change the message participants if they already exist
            if let participants = thread.participants where participants.count == 0 {
                
                guard let participantsJSON = json.value(forKey: "participants") else {
                    throw DataError.invalidInput
                }
                
                let participants = try participantSetFromJSON(participantsJSON)
                thread.participants = participants
            }
            
            try savePrivateContext()
        }
    }
    
    func numberOfDownloadedMessagesOnThread(_ threadID: Int) throws -> Int {
        do {
            if let messageThread = try messageThreadWithID(threadID) {
                if let messages = messageThread.messages {
                    return messages.count
                }
            }
            return 0
        }
    }
    
    func numberOfUnreadMessageThreads() throws -> Int {
        do {
            let threads = try allMessageThreads() as NSArray
            let isNew = threads.value(forKey: "is_new") as! [Int]
            let sum = isNew.reduce(0, combine: +)
            return sum
        }
    }
    
    func messageThreadsThatNeedUpdating() throws -> [Int] {
        do {
            var threadIDs = [Int]()
            let threads = try allMessageThreads()
            for thread in threads {
                if thread.needsUpdating() {
                    if let threadID = thread.thread_id?.intValue {
                        threadIDs.append(threadID)
                    }
                }
            }
            return threadIDs
        }
    }
    
    func allMessagesOnThread(_ threadID: Int) throws -> [CDWSMessage]? {
        do {
            var messages: [CDWSMessage]?
            if let messageThread = try messageThreadWithID(threadID) {
                messages = messageThread.messages?.allObjects as? [CDWSMessage]
            }
            return messages
        }
    }
    
    func subjectForMessageThreadWithID(_ threadID: Int) -> String? {
        do {
            let messageThread = try messageThreadWithID(threadID)
            let subject = messageThread?.subject
            return subject
        } catch {
            return nil
        }
    }
    
    func markMessageThread(_ threadID: Int, unread: Bool) throws {
        do {
            let messageThread = try messageThreadWithID(threadID)
            messageThread?.is_new = unread
            try savePrivateContext()
        }
    }
}
