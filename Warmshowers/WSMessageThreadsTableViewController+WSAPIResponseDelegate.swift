//
//  WSMessageThreadsTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSMessageThreadsTableViewController : WSAPIResponseDelegate {
    
    func requestdidComplete(request: WSAPIRequest) {
        switch request.endPoint.type {
        case .GetMessageThread:
            guard let threadID = request.data as? Int else { return }
            downloadsInProgress.remove(threadID)
            break
        default:
            break
        }
    }
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        switch request.endPoint.type {
        case .GetAllMessageThreads:
            updateAllMessages()
        case .GetMessageThread:
            if downloadsInProgress.count == 0 { didFinishedUpdates() }
        default:
            break
        }
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        switch request.endPoint.type {
        case .GetAllMessageThreads:
            errorCache = error
            didFinishedUpdates()
        case .GetMessageThread:
            errorCache = error
            if downloadsInProgress.count == 0 { didFinishedUpdates() }
        default:
            break
        }
    }
    
}