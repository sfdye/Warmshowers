//
//  WSAPICommunicator+WSAPIRequestHandler.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSAPICommunicator : WSAPIRequestDelegate {
    
    /** Describes how API responses should be handled for each request */
    func request(request: WSAPIRequest, didRecieveHTTPResponse data: NSData?, response: NSURLResponse?, andError error: NSError?) {
        
        guard error == nil else {
            request.delegate.request(request, didFailWithError: error!)
            return
        }
        
        let statusCode = (response as! NSHTTPURLResponse).statusCode
        
        guard request.endPoint.successCodes.contains(statusCode) else {
            let error = WSAPICommunicatorError.ServerError(statusCode: statusCode)
            request.delegate.request(request, didFailWithError: error)
            return
        }
        
        guard let data = data where request.endPoint.doesExpectDataWithResponse() == true else {
            let error = WSAPICommunicatorError.NoData
            request.delegate.request(request, didFailWithError: error)
            return
        }
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            try request.endPoint.request(request, needsToParseJSON: json)
            request.delegate.request(request, didSucceedWithData: nil)
        } catch let error {
            request.delegate.request(request, didFailWithError: error)
        }
    }
    
    /** Called when a request finishes with no errors */
    func request(request: WSAPIRequest, didSucceedWithData data: AnyObject?) {
        
        // notify the requester
        request.requester?.didRecieveAPISuccessResponse(data)
        
        // remove request from queu
        removeRequestFromQueue(request)
    }
    
    /** Called when a request fails with an error */
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        
        // notify the requester
        request.requester?.didRecieveAPIFailureResponse(error)
        
        // remove request from queu
        removeRequestFromQueue(request)
    }
}