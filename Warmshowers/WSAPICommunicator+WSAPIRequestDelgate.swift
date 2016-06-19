//
//  WSAPICommunicator+WSAPIRequestHandler.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

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
            
            var body: String?
            if let data = data {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                    if json.count > 0 {
                        body = json.objectAtIndex(0) as? String
                    }
                } catch {
                    // Leave body as nil
                }
            }

            let error = WSAPICommunicatorError.ServerError(statusCode: statusCode, body: body)
            request.delegate.request(request, didFailWithError: error)
            return
        }
        
        guard let data = data where request.endPoint.doesExpectDataWithResponse() == true else {
            let error = WSAPICommunicatorError.NoData
            request.delegate.request(request, didFailWithError: error)
            return
        }
        
        request.status = .Parsing
        
        switch request.endPoint.type {
        case .ImageResource:
            // Image resouces
            if let image = UIImage(data: data) {
                request.delegate.request(request, didSucceedWithData: image)
            } else {
                request.delegate.request(request, didFailWithError: WSAPIEndPointError.ParsingError(endPoint: request.endPoint.path, key: nil))
            }
        default:
            // Text resources
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
    }
    
    func request(request: WSAPIRequest, didSucceedWithData data: AnyObject?) {
        
        // notify the requester
        request.requester?.requestdidComplete(request)
        request.requester?.request(request, didSuceedWithData: data)
        
        // remove request from queue
        removeRequestFromQueue(request)
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        
        // notify the requester
        request.requester?.requestdidComplete(request)
        request.requester?.request(request, didFailWithError: error)
        
        // remove request from queue
        removeRequestFromQueue(request)
    }
}