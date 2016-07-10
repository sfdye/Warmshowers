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
    var acceptType: AcceptType { get }
    
    /** Specifies if requests for this end point require authorization header fields. Default to true. */
    var requiresAuthorization: Bool { get }
    
    /** Provides a set of status codes that represent successful responses. Defaults to 200. */
    var successCodes: Set<Int> { get }
    
    /** Provides the end point path provided path parameters. */
    func urlWithHostURL(hostURL: NSURL, andParameters parameters: AnyObject?) throws -> NSURL
    
    /** Adds parameters to requests about to be sent to this end point. */
    func HTTPBodyWithData(data: AnyObject?) throws -> String
    
    /** Defines if responses from the end point are expected to include data. */
    func doesExpectDataWithResponse() -> Bool
    
    /** Describes how plain text recieved from this endpoint should be parsed. */
    func request(request: WSAPIRequest, didRecievedResponseWithText text: String) throws -> AnyObject?
    
    /** Describes how json recieved from this endpoint should be parsed. Returns objects initialised with the json data. */
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject?
    
    /** Provides mock end point responses for testing. */
    func generateMockResponseForURLRequest(urlRequest: NSMutableURLRequest) -> (NSData?, NSURLResponse?, NSError?)
}

extension WSAPIEndPointProtocol {
    
    var name: String { return type.name }
    
    var httpScheme: HttpScheme { return .HTTPS }
    
    var requiresAuthorization: Bool { return type != .Login || type != .Token }
    
    var acceptType: AcceptType { return .JSON }
    
    var successCodes: Set<Int> { return [200] }
    
    func HTTPBodyWithData(data: AnyObject?) throws -> String {
        assertionFailure("addParametersToRequest:withData: not implemented for end point \(type.name)")
        return ""
    }
    
    func doesExpectDataWithResponse() -> Bool { return true }
    
    func request(request: WSAPIRequest, didRecievedResponseWithText text: String) throws -> AnyObject? { return nil }
    
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject? { return nil }
    
    func generateMockResponseForURLRequest(urlRequest: NSMutableURLRequest) -> (NSData?, NSURLResponse?, NSError?) {
        return (nil, nil, nil)
    }
    
}
