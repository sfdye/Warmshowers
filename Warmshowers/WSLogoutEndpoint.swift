//
//  WSLogoutEndpoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSLogoutEndPoint : WSAPIEndPointProtocol {
    
    static let sharedEndPoint = WSLogoutEndPoint()
    
    var type: WSAPIEndPoint { return .Logout }
    
    var path: String { return "/services/session/token" }
    
    var method: HttpMethod { return .Get }
    
    var accept: AcceptType { return .PlainText }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
        // Successful requests get a array response with:
        //      - 0 : Not logged in
        //      - 1 : Successful logout
        guard let success = json.objectAtIndex(0) as? Bool else {
            throw WSAPIEndPointError.ParsingError(endPoint: path, key: nil)
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