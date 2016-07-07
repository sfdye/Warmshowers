//
//  WSStoreMessageThreadProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 8/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSStoreMessageThreadProtocol {
    
    /** Returns all the message threads in the store. */
    func allMessageThreads() throws -> [CDWSMessageThread]
    
    /** 
     Checks if a message thread is already in the store by thread id.
     Returns the existing message thread, or a new message thread inserted into the private context. 
     */
    func messageThreadWithID(threadID: Int) throws -> CDWSMessageThread?
    
    /** Checks if a message exists and returns it or a new one if it doesn't exist. */
    func newOrExistingMessageThread(threadID: Int) throws -> CDWSMessageThread
    
    /** Adds a message thread to the store with json. */
    func addMessageThread(json: AnyObject) throws
    
    /** Returns the number of messages that have been saved to the store for a given thread. */
    func numberOfDownloadedMessagesOnThread(threadID: Int) throws -> Int
    
    func numberOfUnreadMessageThreads() throws -> Int
    
    func messageThreadsThatNeedUpdating() throws -> [Int]
    
    func allMessagesOnThread(threadID: Int) throws -> [CDWSMessage]?
    
    func subjectForMessageThreadWithID(threadID: Int) -> String?
    
    func markMessageThread(threadID: Int, unread: Bool) throws
}