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
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        return hostURL.URLByAppendingPathComponent("/services/rest/message/getThread")
    }
    
    func HTTPBodyParametersWithData(data: AnyObject?) throws -> [String: String] {
        guard let threadID = data as? Int else { throw WSAPIEndPointError.InvalidOutboundData }
        let parameters = ["thread_id": String(threadID)]
        return parameters
    }
    
    func request(request: WSAPIRequest, updateStore store: WSStoreProtocol, withJSON json: AnyObject) throws {
        
        guard let threadID = request.data as? Int else {
            throw WSAPIEndPointError.InvalidOutboundData
        }
        
        guard let messagesJSON = json.valueForKey("messages") as? [AnyObject] else {
            throw WSAPIEndPointError.ParsingError(endPoint: name, key: "messages")
        }
        
        let threadPredicate = NSPredicate(format: "p_thread_id == %d", threadID)
        guard let thread = try? store.retrieve(WSMOMessageThread.self, sortBy: nil, isAscending: true, predicate: threadPredicate).first else {
            throw WSAPIEndPointError.NoMessageThreadForMessage
        }
        
        do {
            for messageJSON in messagesJSON {

                let message = try store.newOrExisting(WSMOMessage.self, withJSON: messageJSON)
                message.thread = thread
                
                guard let author_uid = JSON.optionalForKey("author", fromDict: messageJSON , withType: Int.self)  else {
                    throw WSAPIEndPointError.ParsingError(endPoint: name, key: "author")
                }
                
                let participantPredicate = NSPredicate(format: "p_uid == %d", author_uid)
                guard let author = try? store.retrieve(WSMOUser.self, sortBy: nil, isAscending: true, predicate: participantPredicate).first else {
                    throw WSAPIEndPointError.NoAuthorForMessage
                }
                
                message.author = author
            }
            
            try store.savePrivateContext()
        }
    }
}