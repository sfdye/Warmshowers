//
//  WSGetAllMessageThreadsEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSGetAllMessageThreadsEndPoint: WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .GetAllMessageThreads
    
    var httpMethod: HttpMethod = .Post
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        return hostURL.URLByAppendingPathComponent("/services/rest/message/get")
    }
    
    func HTTPBodyParametersWithData(data: AnyObject?) throws -> [String: String] {
        // End point uses HTTP POST. However no body parameters are required.
        return [String: String]()
    }
    
    func request(request: WSAPIRequest, updateStore store: WSStoreProtocol, withJSON json: AnyObject) throws {
        
        guard let threadsJSON = json as? [AnyObject] else {
            throw WSAPIEndPointError.ParsingError(endPoint: name, key: nil)
        }
        
        do {
            try store.performBlockInPrivateContextAndWait({ (context) in
                
                var threadIDs = Set<Int>()
                for threadJSON in threadsJSON {
                    let threadID = try JSON.nonOptionalForKey("thread_id", fromDict: threadJSON, withType: Int.self)
                    threadIDs.insert(threadID)
                    let thread = try store.newOrExisting(WSMOMessageThread.self, withJSON: threadJSON, context: context)
                    
                    // Don't need change the message participants if they already exist
                    if let existingParticipants = thread.participants where existingParticipants.count == 0 {
                        
                        guard let participantsJSON = threadJSON.valueForKey("participants") as? [AnyObject] else {
                            throw WSAPIEndPointError.ParsingError(endPoint: self.name, key: "participants")
                        }
                        
                        var participants = Set<WSMOUser>()
                        for participantJSON in participantsJSON {
                            let participant = try store.newOrExisting(WSMOUser.self, withJSON: participantJSON, context: context)
                            participants.insert(participant)
                        }
                        thread.participants = participants
                    }
                }
                
                try context.save()
                
                // Delete all threads that are not in the json
                let oldMessageThreads = try store.retrieve(WSMOMessageThread.self, sortBy: nil, isAscending: true, predicate: nil, context: context)
                
                for thread in oldMessageThreads {
                    if !threadIDs.contains(thread.thread_id!) {
                        thread.managedObjectContext?.deleteObject(thread)
                    }
                }
                
                try context.save()
            })
        }
    }
    
}