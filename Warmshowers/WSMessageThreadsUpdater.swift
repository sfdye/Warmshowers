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
class WSMessageThreadsUpdater : WSRequestWithCSRFToken {
    
    var moc: NSManagedObjectContext!
    var error: NSError?
    
    init(moc: NSManagedObjectContext) {
        super.init()
        self.moc = moc
    }
    
    // Downloads messages and updates the thread
    //
    override func request() {
        
        guard let token = tokenGetter.token, let service = WSRestfulService(type: .getAllMessageThreads) else {
            failure?()
            return
        }
        
        guard let request = WSRequest.requestWithService(service, token: token) else {
            failure?()
            return
        }
        
        task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            // Guard against failed http requests
            guard let data = data, let _ = response where error == nil else {
                self.error = error
                self.failure?()
                return
            }
            
            guard let json = WSRequest.jsonDataToJSONObject(data) else {
                self.failure?()
                return
            }
            
            do {
                try self.updateMessageThreadsInStore(json)
                self.success?()
            } catch let error {
                self.error = error as NSError
                self.failure?()
            }
        })
        task.resume()
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
        
        print("deleting threads")
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
        print("saving")
        

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