//
//  APIRequest.swift
//  Powershop
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

/**
 Defines a API request so NSURLRequests can be formed and tracked by the HTTP client.
 */
public class APIRequest: Hashable {
    
    /** An instance of the */
    private(set) var endPoint: APIEndPointProtocol!
    
    /** Specifies the http method that the end point accepts. */
    private(set) var method: HTTP.Method
    
    /** The object that initiated the request. The final response for the request will be sent to this object. */
    var requester: APIResponseDelegate?
    
    /** The request delegate. */
    var delegate: APIRequestDelegate!
    
    /** Parameters submitted with the request that may be required to build the URL for the request. */
    public var parameters: Any?
    
    /** Data submitted with the request that may be submitted in the HTTP request body. */
    public var data: Any?
    
    /** The status of the request as it is processed by the API Client. */
    var status: APIRequestStatus = .created
    
        
    // MARK: Hashable
    
    var madeAt: Date
    public var hashValue: Int { return madeAt.hashValue }
    
    
    // MARK: Initialiser
    
    init(withEndPoint endPoint: APIEndPointProtocol, httpMethod method: HTTP.Method, requester: APIResponseDelegate?, parameters: Any? = nil, andData data: Any? = nil) {
        self.endPoint = endPoint
        self.method = method
        self.requester = requester
        self.parameters = parameters
        self.data = data
        self.madeAt = Date()
    }
    
    static func shouldAddBodyToURLRequest(withHttpMethod httpMethod: HTTP.Method) -> Bool {
        switch httpMethod {
        case .get, .head, .trace, .options, .connect:
            return false
        default:
            return true
        }
    }
    
}

// MARK: Equatable

public func ==(lhs: APIRequest, rhs: APIRequest) -> Bool {
    return lhs.hashValue == rhs.hashValue
}