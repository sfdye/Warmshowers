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
    
    var type: WSAPIEndPoint { return .logout }
    
    var path: String { return "/services/session/token" }
    
    var method: HttpMethod { return .Get }
    
    var accept: AcceptType { return .PlainText }
    
    func request(_ request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? {
        
        // Successful requests get a array response with:
        //      - 0 : Not logged in
        //      - 1 : Successful logout
        guard let success = json.object(0) as? Bool else {
            throw WSAPIEndPointError.parsingError(endPoint: path, key: nil)
        }
        
        // Update the session state.
//        WSSessionState.
        
        return nil
    }
    
    func generateMockResponseForURLRequest(_ urlRequest: NSMutableURLRequest) -> (Data?, URLResponse?, NSError?) {
        assertionFailure("No testing data added")
        let data = Data()
        let response = URLResponse()
        return (data, response, nil)
    }
}
