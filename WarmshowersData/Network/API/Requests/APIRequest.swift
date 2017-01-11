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
    
    public var endPointType: APIEndPoint { return endPoint.type }
    
    /** An instance of the */
    private(set) var endPoint: APIEndPointProtocol!
    
    /** Specifies the http method that the end point accepts. */
    private(set) var method: HTTP.Method
    
    /** Specifies if the request should ignore cached data and force loading from the network. */
    private(set) var ignoreCache: Bool
    
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
    public var hashValue: Int { return Int(madeAt.timeIntervalSince1970 * 1000000) }
    
    
    // MARK: Initialiser
    
    init(withEndPoint endPoint: APIEndPointProtocol, httpMethod method: HTTP.Method, requester: APIResponseDelegate?, parameters: Any? = nil, andData data: Any? = nil, ignoreCache: Bool = false) {
        self.endPoint = endPoint
        self.method = method
        self.requester = requester
        self.parameters = parameters
        self.data = data
        self.madeAt = Date()
        self.ignoreCache = ignoreCache
    }
    
    static func urlRequest(fromRequest request: APIRequest) throws -> URLRequest {
        
        let hostURL = try request.delegate.hostURLForRequest(request)
        let url = try request.endPoint.url(withHostURL: hostURL, andParameters: request.parameters)
        
        // URL Request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        if request.ignoreCache {
            urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        } else {
            urlRequest.cachePolicy = request.endPoint.cachePolicyForRequest(request)
        }
        
        // Add header parameters
        urlRequest.addValue(request.endPoint.acceptType.rawValue, forHTTPHeaderField: "Accept")
        
        // Add body parameters.
        let outboundDataMethods: [HTTP.Method] = [.post, .put, .delete, .patch]
        if outboundDataMethods.contains(request.method) {
            urlRequest.httpBody = try request.endPoint.httpBody(fromData: request.data, forMethod: request.method, withEncoder: ParameterEncoding())
            if let contentType = request.endPoint.contentType(forMethod: request.method)?.rawValue {
                urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            } else {
                assertionFailure("A valid content type must be specified for requests with body parameters.")
            }
        }
        
        return urlRequest
    }
    
}

// MARK: Equatable

public func ==(lhs: APIRequest, rhs: APIRequest) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
