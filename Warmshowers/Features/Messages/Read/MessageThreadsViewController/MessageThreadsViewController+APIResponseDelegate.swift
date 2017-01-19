//
//  MessageThreadsViewController+APIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import WarmshowersData

extension MessageThreadsViewController: APIResponseDelegate {
    
    func requestDidComplete(_ request: APIRequest) {
        switch request.endPointType {
        case .messageThread:
            guard let threadID = request.data as? Int else { return }
            downloadsInProgress.remove(threadID)
        default:
            break
        }
    }
    
    func request(_ request: APIRequest, didSucceedWithData data: Any?) {
        switch request.endPointType {
        case .messageThreads:
            updateAllMessages()
        case .messageThread:
            if downloadsInProgress.count == 0 { didFinishedUpdates() }
        default:
            break
        }
    }
    
    func request(_ request: APIRequest, didFailWithError error: Error) {
        switch request.endPointType {
        case .messageThreads:
            errorCache = error
            didFinishedUpdates()
        case .messageThread:
            errorCache = error
            if downloadsInProgress.count == 0 { didFinishedUpdates() }
        default:
            break
        }
    }
    
}
