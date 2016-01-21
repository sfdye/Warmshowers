//
//  WSMessageThreadUpdater.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

class WSMessageThreadUpdater : WSRequestWithCSRFToken {
    
    var messageThread: CDWSMessageThread!
    var moc: NSManagedObjectContext!
    var json: AnyObject?
    
    init(messageThread: CDWSMessageThread, inManagedObjectContext moc: NSManagedObjectContext) {
        super.init()
        self.messageThread = messageThread
        self.moc = moc
    }
    
    // Downloads messages and updates the thread
    //
    override func request() {
        
        guard let messageThread = messageThread, let token = tokenGetter.token else {
            failure?()
            return
        }
        
        guard let threadID = messageThread.thread_id?.integerValue else {
            failure?()
            return
        }
        
        // Guard against unneccessarily updating
        if !messageThread.needsUpdating() {
            success?()
            return
        }
        
        guard let service = WSRestfulService(type: .getMessageThread) else {
            failure?()
            return
        }
        
//        var params = [String: String]()
//        params["thread_id"] = String(threadID)
        let params: [String: String] = ["thread_id": String(threadID)]

        guard let request = WSRequest.requestWithService(service, params: params, token: token) else {
            failure?()
            return
        }
        
        task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            // Guard against failed http requests
            guard let data = data, let _ = response where error == nil else {
                self.failure?()
                return
            }

            guard let json = WSRequest.jsonDataToJSONObject(data) else {
                self.failure?()
                return
            }
            
            guard let messagesJSON = json.valueForKey("messages") as? NSArray else {
                self.failure?()
                return
            }
            
            var messages = [CDWSMessage]()
            
            // Parse the json
            for messageJSON in messagesJSON {
                do {
                    let message = try self.messageWithJSON(messageJSON, forMessageThread: messageThread)
                    messages.append(message)
                    if let new = message.is_new?.boolValue {
                        messageThread.is_new = new
                    }
                } catch DataError.InvalidInput {
                    print("Failed to save message due to invalid input")
                } catch CoreDataError.FailedFetchReqeust {
                    print("Failed to save message due to a failed Core Data fetch request")
                } catch {
                    print("Failed to create message participant for an unknown error")
                }
            }
            
            self.messageThread.messages = NSSet(array: messages)
            
            self.success?()
        })
        task.resume()
    }

    // Converts JSON data for a single message threads into a managed object
    //
    func messageWithJSON(json: AnyObject, forMessageThread messageThread: CDWSMessageThread) throws -> CDWSMessage {
        
        // Abort if the message id can not be found.
        guard let message_id = json.valueForKey("mid")?.integerValue else {
            print("Recieved message with no ID")
            throw DataError.InvalidInput
        }
        
        guard let authorUID = json.valueForKey("author")?.integerValue else {
            print("Recieved message with no author")
            throw DataError.InvalidInput
        }
        
        guard let author = messageThread.participantWithUID(authorUID) else {
            print("Author no in the thread participants")
            throw DataError.InvalidInput
        }
        
        // Create a new message object in the moc
        let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: moc) as! CDWSMessage
        message.author = author
        
        // Update the message thread
        do {
            try message.updateWithJSON(json)
        } catch {
            print("Failed to update message thread with id \(message_id)")
        }
        
        return message
    }
    
}