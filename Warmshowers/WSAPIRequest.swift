//
//  WSAPIRequest.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

/**
 Defines a api request so that requests can be tracked by the HTTP client
 */
class WSAPIRequest : Hashable {
    
    /** An instance of the */
    var endPoint: WSAPIEndPointProtocol!
    
    /** The request delegate. */
    var delegate: WSAPIRequestDelegate!
    
    /** The object that initiated the request. The final response for the request will be sent to this object. */
    var requester: WSAPIResponseDelegate?
    
    /** Parameters submitted with the request that may be required to build the URL for the request. */
    var parameters: Any?
    
    /** Data submitted with the request that may be submitted in the HTTP request body. */
    var data: Any?
    
    /** The status of the request as it is processed by the API Client. */
    var status: WSAPIRequestStatus = .created
    
    
    // MARK: Hashable
    
    var madeAt: Date
    var hashValue: Int { return Int(self.madeAt.timeIntervalSince1970) }
    
    
    // MARK: Initialiser
    
    init(endPoint: WSAPIEndPointProtocol, withDelegate delegate: WSAPIRequestDelegate, requester: WSAPIResponseDelegate?, data: Any? = nil, andParameters parameters: Any? = nil) {
        self.madeAt = Date()
        self.requester = requester
        self.delegate = delegate
        self.endPoint = endPoint
        self.parameters = parameters
        self.data = data
    }
    
    func urlRequest() throws -> URLRequest {
        
        let endPointHTTPScheme = endPoint.httpScheme
        
        guard let hostURL = delegate.hostForRequest(self).hostURLWithHTTPScheme(endPointHTTPScheme) else {
            throw WSAPIRequestError.invalidHostURL
        }
        
        do {
            let url = try endPoint.url(withHostURL: hostURL, andParameters: parameters)
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = endPoint.httpMethod.rawValue
            urlRequest.addValue(endPoint.acceptType.rawValue, forHTTPHeaderField: "Accept")
            if endPoint.httpMethod == .Post {
                let parameters = try endPoint.HTTPBodyParameters(withData: data)
                let body = HttpBody.bodyStringWithParameters(parameters)
                urlRequest.httpBody = body.data(using: String.Encoding.utf8)
            }
            return urlRequest
        }
    }
    
}

// MARK: Equatable

func ==(lhs: WSAPIRequest, rhs: WSAPIRequest) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
