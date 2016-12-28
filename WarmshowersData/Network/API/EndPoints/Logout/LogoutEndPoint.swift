//
//  LogoutEndpoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class LogoutEndPoint : APIEndPointProtocol {
    
    var type: APIEndPoint = .logout
    
    var accept: ContentType = .json
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/user/logout")
    }
    
    func httpBody(fromData data: Any?, forMethod method: HTTP.Method, withEncoder encoder: APIRequestDataEncoder) throws -> Data? {
        // POST but no parameters sent.
        return nil
    }
    
    func request(_ request: APIRequest, didRecieveResponseWithJSON json: Any, parser: JSONParser) throws -> Any? {
        
        guard let json = json as? [Any] else {
            throw APIEndPointError.parsingError(endPoint: name, key: nil)
        }
        
        // Successful requests get a array response with:
        //      - 0 : Not logged in
        //      - 1 : Successful logout
        guard let success = json[0] as? Bool else {
            throw APIEndPointError.parsingError(endPoint: name, key: nil)
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
