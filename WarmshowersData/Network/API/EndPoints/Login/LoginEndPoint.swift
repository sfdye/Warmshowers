//
//  LoginEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct LoginEndPoint : APIEndPointProtocol {
    
    var type: APIEndPoint = .login
    
    var requiresAuthorization: Bool = false
    
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL {
        return hostURL.appendingPathComponent("/services/rest/user/login")
    }
    
    func httpBody(fromData data: Any?, forMethod method: HTTP.Method, withEncoder encoder: APIRequestDataEncoder) throws -> Data? {
        
        guard data is APILoginRequest else {
            throw APIEndPointError.invalidOutboundData(endPoint: name, errorDescription: "The \(name) end point must requires APILoginRequest in the request data.")
        }
        
        let params = (data as! APILoginRequest).loginCredentialsAsParameters
        let body = try encoder.body(fromParameters: params)
        return body
    }
    
    func request(_ request: APIRequest, didRecieveResponseWithJSON json: Any, parser: JSONParser) throws -> Any? {
        
        guard let sessionJSON = json as? [String: Any] else {
            throw APIEndPointError.parsingError(endPoint: name, key: nil)
        }
        
        guard let userJSON = sessionJSON["user"] as? [String: Any] else {
            throw APIEndPointError.parsingError(endPoint: name, key: "user")
        }
        
        let uid = try parser.nonOptional(forKey: "uid", fromJSON: userJSON, withType: Int.self)
        
        // Return the UID for the app to save in the session state.
        return uid
    }
    
    func request(_ request: APIRequest, updateSecureStore secureStore: SecureStoreDelegate, withJSON json: Any, parser: JSONParser) throws {
        
        guard let sessionJSON = json as? [String: Any] else {
            throw APIEndPointError.parsingError(endPoint: name, key: nil)
        }
        
        let sessionName = try parser.nonOptional(forKey: "session_name", fromJSON: sessionJSON, withType: String.self)
        let sessid = try parser.nonOptional(forKey: "sessid", fromJSON: sessionJSON, withType: String.self)
        let sessionCookie = sessionName + "=" + sessid
        let token = try parser.nonOptional(forKey: "token", fromJSON: sessionJSON, withType: String.self)
        
        // Save the session authorization data in the keychain.
        try secureStore.setToken(token, andSecret: sessionCookie)
    }
}
