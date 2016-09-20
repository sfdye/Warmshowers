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
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/message/get")
    }
    
    func HTTPBodyParameters(withData data: Any?) throws -> [String: String] {
        // End point uses HTTP POST. However no body parameters are required.
        return [String: String]()
    }
    
    func request(_ request: WSAPIRequest, updateStore store: WSStoreProtocol, withJSON json: Any) throws {
        
        guard let threadsJSON = json as? [Any] else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: nil)
        }
        
        do {
            try store.performBlockInPrivateContextAndWait({ (context) in
                
//                var threadIDs = Set<Int>()
//                for threadJSON in threadsJSON {
//                    let threadID = try JSON.nonOptional(forKey:"thread_id", fromJSON: threadJSON, withType: Int.self)
//                    threadIDs.insert(threadID!)
//                    let thread = try store.newOrExisting(WSMOMessageThread.self, withJSON: threadJSON, context: context)
//                    
//                    // Don't need change the message participants if they already exist
//                    if let existingParticipants = thread.participants , existingParticipants.count == 0 {
//                        
//                        guard let participantsJSON = (threadJSON as? AnyObject)?["participants"] as? [AnyObject] else {
//                            throw WSAPIEndPointError.parsingError(endPoint: self.name, key: "participants")
//                        }
//                        
//                        var participants = Set<WSMOUser>()
//                        for participantJSON in participantsJSON {
//                            let participant = try store.newOrExisting(WSMOUser.self, withJSON: participantJSON, context: context)
//                            participants.insert(participant)
//                        }
//                        thread.participants = participants
//                    }
//                }
                
//                try context.save()
//                
//                // Delete all threads that are not in the json
//                let oldMessageThreads = try store.retrieve(WSMOMessageThread.self, sortBy: nil, isAscending: true, predicate: nil, context: context)
//                
//                for thread in oldMessageThreads {
//                    if !threadIDs.contains(thread.thread_id!) {
//                        thread.managedObjectContext?.delete(thread)
//                    }
//                }
//                
//                try context.save()
            })
        }
    }
    
}
