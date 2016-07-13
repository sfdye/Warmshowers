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
    
    func hostForRequest(request: WSAPIRequest) -> WSAPIHost {
        return host
    }
        
    func request(request: WSAPIRequest, didSucceedWithData data: AnyObject?) {
        
        // notify the requester
        request.requester?.requestDidComplete(request)
        request.requester?.request(request, didSuceedWithData: data)
        
        // remove request from queue
        removeRequestFromQueue(request)
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        
        // notify the requester
        request.requester?.requestDidComplete(request)
        request.requester?.request(request, didFailWithError: error)
        
        // remove request from queue
        removeRequestFromQueue(request)
    }
}