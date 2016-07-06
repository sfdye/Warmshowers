//
//  WSAPICommunicator+WSAPIRequestHandler.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSAPICommunicator : WSAPIRequestDelegate {
    
    func requestShouldBeQueuedWhileOffline(_ request: WSAPIRequest) -> Bool {
        switch request.endPoint.type {
        case .createFeedback:
            return true
        default:
            return false
        }
    }
    
    func request(_ request: WSAPIRequest, didRecieveHTTPResponse data: Data?, response: URLResponse?, andError error: NSError?) {
        request.status = .recievedResponse
        
        guard error == nil else {
            request.delegate.request(request, didFailWithError: error!)
            return
        }
        
        let statusCode = (response as! HTTPURLResponse).statusCode
        
        guard request.endPoint.successCodes.contains(statusCode) else {
            
            var body: String?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if json.count > 0 {
                        body = json.object(0) as? String
                    }
                } catch {
                    // Leave body as nil
                }
            }

            let error = WSAPICommunicatorError.serverError(statusCode: statusCode, body: body)
            request.delegate.request(request, didFailWithError: error)
            return
        }
        
        guard let data = data where request.endPoint.doesExpectDataWithResponse() == true else {
            let error = WSAPICommunicatorError.noData
            request.delegate.request(request, didFailWithError: error)
            return
        }
        
        request.status = .parsing
        
        switch request.endPoint.type {
        case .imageResource:
            // Image resouces
            if let image = UIImage(data: data) {
                request.delegate.request(request, didSucceedWithData: image)
            } else {
                request.delegate.request(request, didFailWithError: WSAPIEndPointError.parsingError(endPoint: request.endPoint.path, key: nil))
            }
        default:
            // Text resources
            do {
                var parsedData: AnyObject? = nil
                switch request.endPoint.accept {
                case .PlainText:
                    if let text = String.init(data: data, encoding: String.Encoding.utf8) {
                        parsedData = try request.endPoint.request(request, didRecievedResponseWithText: text)
                    }
                case .JSON:
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    parsedData = try request.endPoint.request(request, didRecievedResponseWithJSON: json)
                }
                request.delegate.request(request, didSucceedWithData: parsedData)
            } catch let error {
                request.delegate.request(request, didFailWithError: error)
            }
        }
    }
    
    func request(_ request: WSAPIRequest, didSucceedWithData data: AnyObject?) {
        
        // notify the requester
        request.requester?.requestdidComplete(request)
        request.requester?.request(request, didSuceedWithData: data)
        
        // remove request from queue
        removeRequestFromQueue(request)
    }
    
    func request(_ request: WSAPIRequest, didFailWithError error: ErrorProtocol) {
        
        // notify the requester
        request.requester?.requestdidComplete(request)
        request.requester?.request(request, didFailWithError: error)
        
        // remove request from queue
        removeRequestFromQueue(request)
    }
}
