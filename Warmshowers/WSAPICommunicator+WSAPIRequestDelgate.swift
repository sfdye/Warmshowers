//
//  WSAPICommunicator+WSAPIRequestHandler.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSAPICommunicator : WSAPIRequestDelegate {
    
    func requestShouldBeQueuedWhileOffline(request: WSAPIRequest) -> Bool {
        switch request.endPoint.type {
        case .CreateFeedback:
            return true
        default:
            return false
        }
    }
    
    func request(request: WSAPIRequest, didRecieveHTTPResponse data: NSData?, response: NSURLResponse?, andError error: NSError?) {
        request.status = .RecievedResponse
        
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
        
        request.status = .Parsing
        
        do {
            var parsedData: AnyObject? = nil
            switch request.endPoint.accept {
            case .PlainText:
                if let text = String.init(data: data, encoding: NSUTF8StringEncoding) {
                    parsedData = try request.endPoint.request(request, didRecievedResponseWithText: text)
                }
            case .JSON:
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                parsedData = try request.endPoint.request(request, didRecievedResponseWithJSON: json)
            }
            request.delegate.request(request, didSucceedWithData: parsedData)
        } catch let error {
            request.delegate.request(request, didFailWithError: error)
        }
    }
    
    func request(request: WSAPIRequest, didSucceedWithData data: AnyObject?) {
        
        // notify the requester
        request.requester?.didRecieveAPISuccessResponse(data)
        
        // remove request from queu
        removeRequestFromQueue(request)
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        
        // notify the requester
        request.requester?.didRecieveAPIFailureResponse(error)
        
        // remove request from queu
        removeRequestFromQueue(request)
    }
}