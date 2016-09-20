//
//  WSGetMessageThreadEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSGetMessageThreadEndPoint: WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .GetMessageThread
    
    var httpMethod: HttpMethod = .Post
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/message/getThread")
    }
    
    func HTTPBodyParameters(withData data: Any?) throws -> [String: String] {
        guard let threadID = data as? Int else { throw WSAPIEndPointError.invalidOutboundData }
        let parameters = ["thread_id": String(threadID)]
        return parameters
    }
    
    func request(_ request: WSAPIRequest, updateStore store: WSStoreProtocol, withJSON json: Any) throws {
        
        guard let json = json as? [String: Any] else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: nil)
        }
        
        guard let threadID = request.data as? Int else {
            throw WSAPIEndPointError.invalidOutboundData
        }
        
        guard let messagesJSON = json["messages"] as? [Any] else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: "messages")
        }
        
        do {
            try store.performBlockInPrivateContextAndWait({ (context) in
                
                let threadPredicate = NSPredicate(format: "p_thread_id == %d", threadID)
                guard let thread = try? store.retrieve(WSMOMessageThread.self, sortBy: nil, isAscending: true, predicate: threadPredicate, context: context).first else {
                    throw WSAPIEndPointError.noMessageThreadForMessage
                }
                
//                for messageJSON in messagesJSON {
//                    
//                    let message = try store.newOrExisting(WSMOMessage.self, withJSON: messageJSON, context: context)
//                    message.thread = thread
//                    
//                    guard let author_uid = JSON.optional(forKey: "author", fromJSON: messageJSON , withType: Int.self)  else {
//                        throw WSAPIEndPointError.parsingError(endPoint: self.name, key: "author")
//                    }
//                    
//                    let participantPredicate = NSPredicate(format: "p_uid == %d", author_uid)
//                    guard let author = try? store.retrieve(WSMOUser.self, sortBy: nil, isAscending: true, predicate: participantPredicate, context:  context).first else {
//                        throw WSAPIEndPointError.noAuthorForMessage
//                    }
//                    
//                    message.author = author
//                }
//                
//                try context.save()
            })
        }
    }
}
