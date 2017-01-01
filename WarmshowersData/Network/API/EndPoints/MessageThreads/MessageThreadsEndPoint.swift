//
//  GetAllMessageThreadsEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct MessageThreadsEndPoint: APIEndPointProtocol {
    
    var type: APIEndPoint = .messageThreads
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/message/get")
    }
    
    func httpBody(fromData data: Any?, forMethod method: HTTP.Method, withEncoder encoder: APIRequestDataEncoder) throws -> Data? {
        // POST but no parameters sent.
        return nil
    }
    
    func request(_ request: APIRequest, updateStore store: StoreUpdateDelegate, withJSON json: Any, parser: JSONParser) throws {
        
        guard let threadsJSON = json as? [Any] else {
            throw APIEndPointError.parsingError(endPoint: name, key: nil)
        }
        
        try store.performBlockInPrivateContextAndWait({ (context) in
            
            var threadIDs = Set<Int>()
            for threadJSON in threadsJSON {
                let threadID = try parser.nonOptional(forKey:"thread_id", fromJSON: threadJSON, withType: Int.self)
                threadIDs.insert(threadID)
                let thread: MOMessageThread = try store.newOrExisting(inContext: context, withJSON: threadJSON, withParser: parser)
                
                // Don't need change the message participants if they already exist
                if let existingParticipants = thread.participants, existingParticipants.count == 0 {
                    
                    guard let participantsJSON = (threadJSON as AnyObject)["participants"] as? [Any] else {
                        throw APIEndPointError.parsingError(endPoint: self.name, key: "participants")
                    }
                    
                    var participants = Set<MOUser>()
                    for participantJSON in participantsJSON {
                        let participant: MOUser = try store.newOrExisting(inContext: context, withJSON: participantJSON, withParser: parser)
                        participants.insert(participant)
                    }
                    thread.participants = participants as NSSet?
                }
            }
            
            try context.save()
            
            // Delete all threads that are not in the json
            let oldMessageThreads: [MOMessageThread] = try store.retrieve(inContext: context, withPredicate: nil, andSortBy: nil, isAscending: true)
            
            for thread in oldMessageThreads {
                if !threadIDs.contains(thread.thread_id!) {
                    thread.managedObjectContext?.delete(thread)
                }
            }
            
            try context.save()
        })
    }
    
}
