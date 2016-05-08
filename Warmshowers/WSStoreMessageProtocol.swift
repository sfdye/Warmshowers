//
//  WSStoreMessageProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 8/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSStoreMessageProtocol {
    
    /** Returns all the messages in the store. */
    func allMessages() throws -> [CDWSMessage]
    
    /** 
     Checks if a message is already in the store by message id.
     Returns the existing message, or a new message inserted into the private context.
     */
    func messageWithID(messageID: Int) throws -> CDWSMessage?
    
    /** Checks if a message exists and returns it or a new one if it doesn't exist. */
    func newOrExistingMessage(messageID: Int) throws -> CDWSMessage
    
    /** Adds a message to the store with json. */
    func addMessage(json: AnyObject, onThreadWithID threadID: Int) throws
}