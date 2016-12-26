//
//  MessageThreadsTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension MessageThreadsTableViewController : APIResponseDelegate {
    
    func requestDidComplete(_ request: APIRequest) {
        switch request.endPoint.type {
        case .GetMessageThread:
            guard let threadID = request.data as? Int else { return }
            downloadsInProgress.remove(threadID)
        default:
            break
        }
    }
    
    func request(_ request: APIRequest, didSuceedWithData data: Any?) {
        switch request.endPoint.type {
        case .GetAllMessageThreads:
            updateAllMessages()
        case .GetMessageThread:
            if downloadsInProgress.count == 0 { didFinishedUpdates() }
        default:
            break
        }
    }
    
    func request(_ request: APIRequest, didFailWithError error: Error) {
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
