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
        
        let store = WSStore.sharedStore
        var error: ErrorType?
        store.privateContext.performBlockAndWait { () -> Void in
            
            // Parse the json
            var currentThreadIDs = [Int]()
            for threadJSON in threadsJSON {
                
                // Fail parsing if a message thread doesn't have an ID as it will cause problems later
                guard let threadID = Int.fromJSON(threadJSON, withKey: "thread_id") else {
                    error = WSAPIEndPointError.ParsingError(endPoint: self.name, key: "thread_id")
                    return
                }
                
                do {
                    try store.addMessageThread(threadJSON)
                } catch let storeError {
                    error = storeError
                    return
                }
                
                // Save the thread id
                currentThreadIDs.append(threadID)
            }
            
            // Delete all threads that are not in the json
            do {
                let allMessageThreads = try store.allMessageThreads()
                for messageThread in allMessageThreads {
                    if let threadID = messageThread.thread_id?.integerValue {
                        if !(currentThreadIDs.contains(threadID)){
                            store.privateContext.deleteObject(messageThread)
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