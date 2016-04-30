//
//  WSAPIEndPointProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSAPIEndPointProtocol {
    
    /** Specifies the end point type */
    var type: WSAPIEndPoint { get }
    
    /** Specifies the url for the api end point */
    var path: String { get }
    
    /** Specifies the http method that the service accepts */
    var method: HttpMethod { get }
    
    /** Specifies the acceptable response data format */
    var accept: AcceptType { get }
    
    /** Provides a set of status codes that represent successful responses */
    var successCodes: Set<Int> { get }
    
    /** Defines if responses from the end point are expected to include data */
    func doesExpectDataWithResponse() -> Bool
    
    /** Describes how plain text recieved from this endpoint should be parsed */
    func request(request: WSAPIRequest, didRecievedResponseWithText text: String) throws -> AnyObject?
    
    /** Describes how json recieved from this endpoint should be parsed */
    func request(request: WSAPIRequest, didRecievedResponseWithJSON json: AnyObject) throws -> AnyObject?
    
    /** Provides mock end point responses for testing */
    func generateMockResponseForURLRequest(urlRequest: NSMutableURLRequest) -> (NSData?, NSURLResponse?, NSError?)
}
