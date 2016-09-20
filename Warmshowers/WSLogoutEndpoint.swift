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
    
    var httpMethod: HttpMethod = .Post
    
    var accept: AcceptType = .JSON
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/user/logout")
    }
    
    func HTTPBodyParameters(withData data: Any?) throws -> [String: String] {
        // Logout is a post request. However, it has no path parameters or body data.
        return [String: String]()
    }
    
    func request(_ request: WSAPIRequest, didRecieveResponseWithJSON json: Any) throws -> Any? {
        
        guard let json = json as? [Any] else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: nil)
        }
        
        // Successful requests get a array response with:
        //      - 0 : Not logged in
        //      - 1 : Successful logout
        guard let success = json[0] as? Bool else {
            throw WSAPIEndPointError.parsingError(endPoint: name, key: nil)
        }

        return success
    }
    
    func generateMockResponseForURLRequest(_ urlRequest: NSMutableURLRequest) -> (Data?, URLResponse?, NSError?) {
        assertionFailure("No testing data added")
        let data = Data()
        let response = URLResponse()
        return (data, response, nil)
    }
}
