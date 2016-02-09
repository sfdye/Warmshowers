//
//  WSMessageUpdater.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

class WSMessageUpdater : WSRequestWithCSRFToken, WSRequestDelegate {
    
    var threadID: Int!
    var store: WSMessageStore!
    
    init(threadID: Int, store: WSMessageStore) {
        super.init()
        requestDelegate = self
        self.threadID = threadID
        self.store = store
    }
 
    func requestForDownload() throws -> NSURLRequest {
        do {
        let service = WSRestfulService(type: .getMessageThread)!
        let params: [String: String] = ["thread_id": String(threadID)]
        let request = try WSRequest.requestWithService(service, params: params, token: token)
        return request
        }
    }
    
    func doWithData(data: NSData) {

        guard let json = dataAsJSON() else {
            return
        }
        
        guard let messagesJSON = json.valueForKey("messages") as? NSArray else {
            error = NSError(domain: "WSRequesterDomain", code: 30, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Messages JSON missing messages key", comment: "")])
            return
        }

        store.privateContext.performBlockAndWait {
            
            // Parse the json
            var currentMessageIDs = [Int]()
            for messageJSON in messagesJSON {
                
                // Fail parsing if a message thread doesn't have an ID as it will cause problems later
                guard let messageID = messageJSON.valueForKey("mid")?.integerValue else {
                    self.error = NSError(domain: "WSRequesterDomain", code: 31, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Messages JSON missing message id key", comment: "")])
                    return
                }
                
                do {
                    try self.store.addMessage(messageJSON, onThreadWithID: self.threadID)
                } catch let nserror as NSError {
                    self.error = nserror
                    return
                }
                
                // Save the thread id
                currentMessageIDs.append(messageID)
                
            }
            
            // Delete all messages that are not in the json
            do {
                if let allMessages = try self.store.allMessagesOnThread(self.threadID) {
                    for message in allMessages {
                        if let messageID = message.message_id?.integerValue {
                            if !(currentMessageIDs.contains(messageID)){
                                self.store.privateContext.deleteObject(message)
                            }
                        }
                    }
                }
                try self.store.savePrivateContext()
            } catch let error as NSError {
                self.error = error
                return
            }
        }
    }
    
    // Initiates the update
    //
    func update() {
        self.tokenGetter.start()
    }
}