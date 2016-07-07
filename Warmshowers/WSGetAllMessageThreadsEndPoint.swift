//
//  WSGetAllMessageThreadsEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSGetAllMessageThreadsEndPoint: WSAPIEndPointProtocol {
    
    static let sharedEndPoint = WSGetAllMessageThreadsEndPoint()
    
    var type: WSAPIEndPoint { return .GetAllMessageThreads }
    
    var path: String { return "/services/rest/message/get" }
    
    var method: HttpMethod { return .Post }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
        guard let threadsJSON = json as? NSArray else {
            throw WSAPIEndPointError.ParsingError(endPoint: path, key: nil)
        }
        
//        WSStore.sharedStore.privateContext.performBlockAndWait { () -> Void in
//            
//            // Parse the json
//            var currentThreadIDs = [Int]()
//            for threadJSON in threadsJSON {
//                
//                // Fail parsing if a message thread doesn't have an ID as it will cause problems later
//                guard let threadID = threadJSON.valueForKey("thread_id")?.integerValue else {
//                    self.setError(202, description: "Thread ID missing in message thread JSON.")
//                    return
//                }
//                
//                do {
//                    //                    try WSStore.addMessageThread(threadJSON)
//                } catch let nserror as NSError {
//                    self.error = nserror
//                    return
//                }
//                
//                // Save the thread id
//                currentThreadIDs.append(threadID)
//            }
//            
//            // Delete all threads that are not in the json
//            do {
//                //                let allMessageThreads = try WSStore.allMessageThreads()
//                //                for messageThread in allMessageThreads {
//                //                    if let threadID = messageThread.thread_id?.integerValue {
//                //                        if !(currentThreadIDs.contains(threadID)){
//                //                            WSStore.sharedStore.privateContext.deleteObject(messageThread)
//                //                        }
//                //                    }
//                //                }
//                //                try WSStore.savePrivateContext()
//            } catch let error as NSError {
//                self.error = error
//                return
//            }
//        }
        return nil
    }
}