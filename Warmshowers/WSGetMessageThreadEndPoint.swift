//
//  WSGetMessageThreadEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSGetMessageThreadEndPoint: WSAPIEndPointProtocol {
    
    static let sharedEndPoint = WSGetMessageThreadEndPoint()
    
    var type: WSAPIEndPoint { return .GetMessageThread }
    
    var path: String { return "/services/rest/message/getThread" }
    
    var method: HttpMethod { return .Post }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
        guard let messagesJSON = json.valueForKey("messages") as? NSArray else {
            throw WSAPIEndPointError.ParsingError(endPoint: path, key: "messages")
        }
        
//        WSStore.sharedStore.privateContext.performBlockAndWait {
//            
//            // Parse the json
//            var currentMessageIDs = [Int]()
//            for messageJSON in messagesJSON {
//                
//                // Fail parsing if a message thread doesn't have an ID as it will cause problems later
//                guard let messageID = messageJSON.valueForKey("mid")?.integerValue else {
//                    self.setError(302, description: "Messages JSON missing message id key")
//                    return
//                }
//                
//                do {
//                    try self.store.addMessage(messageJSON, onThreadWithID: self.threadID)
//                } catch let nserror as NSError {
//                    self.error = nserror
//                    return
//                }
//                
//                // Save the thread id
//                currentMessageIDs.append(messageID)
//            }
//            
//            //            // Delete all messages that are not in the json
//            //            do {
//            //                if let allMessages = try store.allMessagesOnThread(self.threadID) {
//            //                    for message in allMessages {
//            //                        if let messageID = message.message_id?.integerValue {
//            //                            if !(currentMessageIDs.contains(messageID)){
//            //                                WSStore.sharedStore.privateContext.deleteObject(message)
//            //                            }
//            //                        }
//            //                    }
//            //                }
//            //                try store.savePrivateContext()
//            //            } catch let error as NSError {
//            //                self.error = error
//            //                return
//            //            }
//        }
        
        return nil
    }
}