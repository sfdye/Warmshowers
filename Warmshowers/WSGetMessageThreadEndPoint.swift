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
        
        var error: ErrorType?
        store.privateContext.performBlockAndWait {
            
            // Parse the json
            var currentMessageIDs = [Int]()
            for messageJSON in messagesJSON {
                
                // Fail parsing if a message thread doesn't have an ID as it will cause problems later
                guard let messageID = Int.fromJSON(messageJSON, withKey: "mid") else {
                    WSAPIEndPointError.ParsingError(endPoint: self.name, key: "mid")
                    return
                }
                
                do {
                    try store.addMessage(messageJSON, onThreadWithID: threadID)
                } catch let storeError {
                    error = storeError
                    return
                }
                
                // Save the thread id
                currentMessageIDs.append(messageID)
            }
            
            // Delete all messages that are not in the json
            do {
                if let allMessages = try store.allMessagesOnThread(threadID) {
                    for message in allMessages {
                        if let messageID = message.message_id?.integerValue {
                            if !(currentMessageIDs.contains(messageID)){
                                store.privateContext.deleteObject(message)
                            }
                        }
                    }
                }
                try store.savePrivateContext()
            } catch let storeError {
                error = storeError
                return
            }
        }
        
        if error != nil { throw error! }
    }
}