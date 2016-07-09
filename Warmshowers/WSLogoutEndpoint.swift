//
//  WSLogoutEndpoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSLogoutEndPoint : WSAPIEndPointProtocol {
    
    var type: WSAPIEndPoint = .Logout
    
    var httpMethod: HttpMethod = .Get
    
    var accept: AcceptType = .PlainText
    
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL {
        return hostURL.URLByAppendingPathComponent("/services/session/token")
    }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
        // Successful requests get a array response with:
        //      - 0 : Not logged in
        //      - 1 : Successful logout
        guard let success = json.objectAtIndex(0) as? Bool else {
            throw WSAPIEndPointError.ParsingError(endPoint: name, key: nil)
        }
        
        // Update the session state.
//        WSSessionState.
        
        return success
    }
    
    func generateMockResponseForURLRequest(urlRequest: NSMutableURLRequest) -> (NSData?, NSURLResponse?, NSError?) {
        assertionFailure("No testing data added")
        let data = NSData()
        let response = NSURLResponse()
        return (data, response, nil)
    }
}