//
//  APIEndPointProtocol.swift
//  Powershop
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol APIEndPointProtocol {
    
    /** Specifies the end point type. */
    var type: APIEndPoint { get }
    
    /** Specifies the name of the end point. The default below returns the string value of the type enum (PSEndPoint). */
    var name: String { get }
    
    /** Specifies the http scheme to use when contacting the end point. Default to https. */
    var httpScheme: HTTP.Scheme { get }
    
    /** Specifies if requests for this end point require authorization header fields. Default to true. */
    var requiresAuthorization: Bool { get }
    
    /** Specifies the acceptable response data format. Defaults to JSON. */
    var acceptType: ContentType { get }
    
    /** Provides a set of status codes that represent successful responses. Defaults to 200. */
    var successCodes: Set<Int> { get }
    
    /** 
     Returns true if a 'data' field is expected in the response for the given request.
     Most Powershop API requests do, so the default for this method returns true. However, some POST requests will receieve a successful response with no data field.
     */
    func doesExpectDataInResponseForRequest(_ request: APIRequest) -> Bool
    
    /** Provides the end point path provided path parameters. */
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL
    
    /** Returns the content type for the posted data for a given method. */
    func contentType(forMethod method: HTTP.Method) -> ContentType?
    
    /** 
     Returns a dictionary of parameters to requests for the given method.
     If no body parameters are required for the request with the given method, nil should be returned.
     */
    func httpBody(fromData data: Any?, forMethod method: HTTP.Method, withEncoder encoder: APIRequestDataEncoder) throws -> Data?
    
    /** Returns the cache policy to use for the given request. */
    func cachePolicyForRequest(_ request: APIRequest) -> URLRequest.CachePolicy
    
    /** Describes how plain text recieved from this endpoint should be parsed. */
    func request(_ request: APIRequest, didRecieveResponseWithText text: String) throws -> Any?
    
    /** Describes how json recieved from this endpoint should be parsed. Returns objects initialised with the json data. */
    func request(_ request: APIRequest, didRecieveResponseWithJSON json: Any, parser: JSONParser) throws -> Any?
    
    /** Provides opportunity to update the store when json is recieved. */
    func request(_ request: APIRequest, updateStore store: StoreUpdateDelegate, withJSON json: Any, parser: JSONParser) throws
    
    /** Provides opportunity to update the secure store when json is recieved. */
    func request(_ request: APIRequest, updateSecureStore secureStore: SecureStoreDelegate, withJSON json: Any, parser: JSONParser) throws
    
    /** Provides mock end point responses for testing. */
    func generateMockResponse(forURLRequest urlRequest: NSMutableURLRequest) -> (Data?, URLResponse?, Error?)
}

extension APIEndPointProtocol {
 
    var name: String { return type.name }
    
    var httpScheme: HTTP.Scheme { return .https }
    
    var requiresAuthorization: Bool { return true }
    
    var acceptType: ContentType { return .json }
    
    var successCodes: Set<Int> { return [200] }
    
    func doesExpectDataInResponseForRequest(_ request: APIRequest) -> Bool { return true }
    
    // All Powershop end point only accept x-www-form-urlencoded data. JSON is not accepted.
    func contentType(forMethod method: HTTP.Method) -> ContentType? { return .xWWWFormURLEncoded }
    
    func httpBody(fromData data: Any?, forMethod method: HTTP.Method, withEncoder encoder: APIRequestDataEncoder) throws -> Data? {
        assertionFailure("bodyParameters(withData:forMethod:) not implemented for end point \(type.name) and HTTP method \(method)")
        return nil
    }
    
    func cachePolicyForRequest(_ request: APIRequest) -> URLRequest.CachePolicy { return .reloadIgnoringLocalAndRemoteCacheData }
    
    func request(_ request: APIRequest, didRecieveResponseWithText text: String) throws -> Any? { return nil }
    
     func request(_ request: APIRequest, didRecieveResponseWithJSON json: Any, parser: JSONParser) throws -> Any? { return nil }
    
    func request(_ request: APIRequest, updateStore store: StoreUpdateDelegate, withJSON json: Any, parser: JSONParser) throws { }
    
    func request(_ request: APIRequest, updateSecureStore secureStore: SecureStoreDelegate, withJSON json: Any, parser: JSONParser) throws { }
    
    func generateMockResponse(forURLRequest urlRequest: NSMutableURLRequest) -> (Data?, URLResponse?, Error?) {
        return (nil, nil, nil)
    }
    
}
