//
//  MarkMessageEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct MarkThreadReadEndPoint: APIEndPointProtocol {
    
    var type: APIEndPoint = .markThreadRead
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/message/markThreadRead")
    }
    
    func httpBody(fromData data: Any?, forMethod method: HTTP.Method, withEncoder encoder: APIRequestDataEncoder) throws -> Data? {
        
        guard let readState = data as? MessageThreadReadState else {
            throw APIEndPointError.invalidOutboundData(endPoint: name, errorDescription: "The \(name) end point requires a MessageThreadReadState in the request data.")
        }
        var params = [String: String]()
        params["thread_id"] = String(readState.threadID)
        params["status"] = String(readState.read ? 0 : 1)
        let body = try encoder.body(fromParameters: params)
        return body
    }
    
     func request(_ request: APIRequest, didRecieveResponseWithJSON json: Any, parser: JSONParser) throws -> Any? {
        
        guard let json = json as? [Any], json.count == 1 else { return nil }
        
        // Successful requests get a response with "1" in the body
        if let success = json[0] as? Bool {
            return success
        }
        
        return nil
    }
    
    func request(_ request: APIRequest, updateStore store: StoreUpdateDelegate, withJSON json: Any, parser: JSONParser) throws {
        guard let readState = request.data as? MessageThreadReadState else { return }
        guard let json = json as? [Any], json.count == 1 else { return }
        
        // Successful requests get a response with "1" in the body
        if let _ = json[0] as? Bool {
            // Update the message state in the store.
            let predicate = NSPredicate(format: "p_thread_id == %d", readState.threadID)
            try store.performBlockInPrivateContextAndWait({ (context) in
                if let messageThread: MOMessageThread = try store.retrieve(inContext: context, withPredicate: predicate, andSortBy: nil, isAscending: true).first {
                    messageThread.is_new = !readState.read
                    try context.save()
                }
            })
        }
    }
}
