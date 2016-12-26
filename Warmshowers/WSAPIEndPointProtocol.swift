//
//  WSAPIEndPointProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSAPIEndPointProtocol {
    
    /** Specifies the end point type. */
    var type: WSAPIEndPoint { get }
    
    /** Specifies the name of the end point. The default below returns the string value of the type enum (WSEndPoint). */
    var name: String { get }
    
    /** Specifies the http scheme to use when contacting the end point. Default to httWS. */
    var httpScheme: HttpScheme { get }
    
    /** Specifies the http method that the end point accepts. */
    var httpMethod: HttpMethod { get }
    
    /** Specifies the acceptable response data format. Defaults to JSON. */
    var acceptType: ContentType { get }
    
    /** Specifies if requests for this end point require authorization header fields. Default to true. */
    var requiresAuthorization: Bool { get }
    
    /** Provides a set of status codes that represent successful responses. Defaults to 200. */
    var successCodes: Set<Int> { get }
    
    /** Provides the end point path provided path parameters. */
    func url(withHostURL hostURL: URL, andParameters parameters: Any?) throws -> URL
    
    /** Adds parameters to requests about to be sent to this end point. */
    func httpBody(fromData data: Any?, forMethod method: HTTP.Method) throws -> Data?
    
    /** Defines if responses from the end point are expected to include data. */
    func doesExpectDataWithResponse() -> Bool
    
    /** Describes how plain text recieved from this endpoint should be parsed. */
    func request(_ request: WSAPIRequest, didRecieveResponseWithText text: String) throws -> Any?
    
    /** Describes how json recieved from this endpoint should be parsed. Returns objects initialised with the json data. */
    func request(_ request: WSAPIRequest, didRecieveResponseWithJSON json: Any) throws -> Any?
    
    /** Provides opportunity to update the store when json is recieved. */
    func request(_ request: WSAPIRequest, updateStore store: WSStoreProtocol, withJSON json: Any) throws
    
    /** Provides mock end point responses for testing. */
    func generateMockResponse(forURLRequest urlRequest: NSMutableURLRequest) -> (Data?, URLResponse?, NSError?)
}

extension WSAPIEndPointProtocol {
    
    var name: String { return type.name }
    
    var httpScheme: HttpScheme { return .HTTPS }
    
    var requiresAuthorization: Bool { return type != .Login || type != .Token }
    
    var acceptType: ContentType { return .JSON }
    
    var successCodes: Set<Int> { return [200] }
    
    func httpBody(fromData data: Any?, forMethod method: HTTP.Method) throws -> Data? {
        assertionFailure("addParametersToRequest:withData: not implemented for end point \(type.name)")
        return [String: String]()
    }
    
    func doesExpectDataWithResponse() -> Bool { return true }
    
    func request(_ request: WSAPIRequest, didRecieveResponseWithText text: String) throws -> Any? { return nil }
    
    func request(_ request: WSAPIRequest, didRecieveResponseWithJSON json: Any) throws -> Any? { return nil }
    
    func request(_ request: WSAPIRequest, updateStore store: WSStoreProtocol, withJSON json: Any) throws { }
    
    func generateMockResponse(forURLRequest urlRequest: NSMutableURLRequest) -> (Data?, URLResponse?, NSError?) {
        return (nil, nil, nil)
    }
    
}
