//
//  APICommunicator+APIRequestHandler.swift
//  Powershop
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension APICommunicator: APIRequestDelegate {
    
    func hostURLForRequest(_ request: APIRequest) throws -> URL {
        guard delegate != nil else { throw APICommunicatorError.noDelegate }
        var urlComponents = URLComponents()
        urlComponents.scheme = request.endPoint.httpScheme.rawValue
        let subdomain = delegate!.subDomainForRequest(request)
        let domain = delegate!.hostDomainForRequest(request)
        urlComponents.host = "\(subdomain).\(domain)"
        guard let url = urlComponents.url else { throw APICommunicatorError.invalidHostURL }
        return url
    }
    
    func request(_ request: APIRequest, didSucceedWithData data: Any?) {
        
        // Notify the requester.
        request.requester?.requestDidComplete(request)
        request.requester?.request(request, didSucceedWithData: data)
        
        // Remove request from queue.
        removeRequestFromQueue(request)
        
        log("Finished request: \(request.hashValue). \(requests.count) remaining requests.")
        logQueueState()
    }
    
    func request(_ request: APIRequest, didFailWithError error: Error) {
        
        // Notify the requester.
        request.requester?.requestDidComplete(request)
        request.requester?.request(request, didFailWithError: error)
        
        // Remove request from queue.
        removeRequestFromQueue(request)
        
        log("Finished request: \(request.hashValue). \(requests.count) remaining requests.")
        logQueueState()
    }
    
}
