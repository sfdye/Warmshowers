//
//  GetMessageThreadEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct MessageThreadEndPoint: APIEndPointProtocol {
    
    var type: APIEndPoint = .messageThread

    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/message/getThread")
    }
    
    func httpBody(fromData data: Any?, forMethod method: HTTP.Method, withEncoder encoder: APIRequestDataEncoder) throws -> Data? {
        
        guard let threadID = data as? Int else {
            throw APIEndPointError.invalidOutboundData(endPoint: name, errorDescription: "The \(name) end point must recieve a valid thread id in the request data.")
        }
        
        let params = ["thread_id": String(threadID)]
        let body = try encoder.body(fromParameters: params)
        return body
    }
    
    func request(_ request: APIRequest, updateStore store: StoreUpdateDelegate, withJSON json: Any, parser: JSONParser) throws {
        
        guard let json = json as? [String: Any] else {
            throw APIEndPointError.parsingError(endPoint: name, key: nil)
        }
        
        guard let threadID = request.data as? Int else {
            throw APIEndPointError.invalidOutboundData(endPoint: name, errorDescription: "The \(name) end point must recieve a valid thread id in the request data.")
        }
        
        guard let messagesJSON = json["messages"] as? [Any] else {
            throw APIEndPointError.parsingError(endPoint: name, key: "messages")
        }
        
        try store.performBlockInPrivateContextAndWait({ (context) in
            
            let threadPredicate = NSPredicate(format: "p_thread_id == %d", threadID)
            guard let thread: MOMessageThread = try store.retrieve(inContext: context, withPredicate: threadPredicate, andSortBy: nil, isAscending: true).first else {
                throw APIEndPointError.storeError(description: "No message thread for message.")
            }
            
            for messageJSON in messagesJSON {
                
                let message: MOMessage = try store.newOrExisting(inContext: context, withJSON: messageJSON, withParser: parser)
                message.thread = thread
                
                guard let author_uid = JSON.shared.optional(forKey: "author", fromJSON: messageJSON, withType: Int.self)  else {
                    throw APIEndPointError.parsingError(endPoint: self.name, key: "author")
                }
                
                let participantPredicate = NSPredicate(format: "p_uid == %d", author_uid)
                guard let author: MOUser = try store.retrieve(inContext: context, withPredicate: participantPredicate, andSortBy: nil, isAscending: true).first else {
                    throw APIEndPointError.storeError(description: "No author for message.")
                }
                
                message.author = author
            }
            
            try context.save()
        })
    }
}
