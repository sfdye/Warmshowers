//
//  WSMessageThreadsUpdater.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 23/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

// This class is for downloading message thread data from warmshowers and updating the persistant store
//
class WSMessageThreadsUpdater : WSRequestWithCSRFToken, WSRequestDelegate {
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override init() {
        super.init()
        requestDelegate = self
    }
    
    func requestForDownload() -> NSURLRequest? {
        let service = WSRestfulService(type: .getAllMessageThreads)!
        let request = WSRequest.requestWithService(service, token: token)
        return request
    }
    
    func doWithData(data: NSData) {
        
        guard let json = dataAsJSON() else {
            return
        }
        
        do {
            try self.updateMessageThreadsInStore(json)
        } catch let error {
            self.error = error as NSError
        }
    }
    
    // Parses JSON containing message threads
    //
    func updateMessageThreadsInStore(json: AnyObject) throws {
        
        guard let json = json as? NSArray else {
            throw DataError.InvalidInput
        }
        
        // Get the currently saved message threads from the store
        let request = NSFetchRequest(entityName: "MessageThread")
        var threads: [CDWSMessageThread]
        do {
            threads = try moc.executeFetchRequest(request) as! [CDWSMessageThread]
        }
        
        // Parse the json
        var currentThreadIDs = [Int]()
        for threadJSON in json {
            // Fail parsing if a message thread doesn't have an ID as it will cause problems later
            guard let threadID = threadJSON.valueForKey("thread_id")?.integerValue else {
                throw DataError.InvalidInput
            }
            currentThreadIDs.append(threadID)
            // If the thread exists in the mocel update it and move on
            if let thread = threads.filter({ $0.thread_id == threadID }).first {
                do {
                    try thread.updateWithJSON(threadJSON)
                }
                continue
            }
            
            // Else get the participants of the new thread
            guard let participantsJSON = threadJSON.valueForKey("participants") else {
                throw DataError.InvalidInput
            }
            
            // If the thread is new, insert it in the context
            let thread = NSEntityDescription.insertNewObjectForEntityForName("MessageThread", inManagedObjectContext: moc) as! CDWSMessageThread
            
            // Get an array of the message participants and add them to the new thread
            var participants: NSSet?
            do {
                try participants = getMessageParticipantSet(participantsJSON)
                thread.participants = participants
                thread.messages = NSSet()
                try thread.updateWithJSON(threadJSON)
            }
            
            threads.append(thread)
        }
        
        // Delete all threads that are not in the json
        var indexesToDelete = [Int]()
        for (index, thread) in threads.enumerate() {
            let threadID = thread.thread_id!.integerValue
            if !currentThreadIDs.contains(threadID) {
                indexesToDelete.append(index)
            }
        }
        for index in indexesToDelete {
            let thread = threads[index]
            moc.deleteObject(thread)
            threads.removeAtIndex(index)
        }
        
        // Save the message threads to the store
        do {
            try moc.save()
        }
    }
    
    // Makes a set of message participants from JSON data
    //
    func getMessageParticipantSet(json: AnyObject) throws -> NSSet {
        
        guard let users = json as? NSArray else {
            throw DataError.FailedConversion
        }
        
        var participants = [CDWSUser]()
        for user in users {
            
            // Get the user uid of the message participant.
            if let uid = user.valueForKey("uid")?.integerValue {
                
                // Check if the participant exists in the store.
                var participant: CDWSUser
                do {
                    participant = try getUserWithUID(uid)
                }
                
                // Update the message participant data.
                do {
                    try participant.updateFromMessageParticipantJSON(user)
                }
                participants.append(participant)
                
            } else {
                throw DataError.InvalidInput
            }
        }
        
        return NSSet(array: participants)
    }
    
    // Checks if a user is already in the store by uid.
    // Returns the existing user, or a new user inserted into the MOC.
    //
    func getUserWithUID(uid: Int) throws -> CDWSUser {
        
        let request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "uid == %i", uid)
        
        // Try to find the user in the store
        do {
            let users = try moc.executeFetchRequest(request)
            if users.count != 0 {
                if let user = users[0] as? CDWSUser {
                    return user
                }
            }
        } catch {
            throw CoreDataError.FailedFetchReqeust
        }
        
        // User wasn't in the store, so create a new managed object
        let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as! CDWSUser
        return user
    }

}