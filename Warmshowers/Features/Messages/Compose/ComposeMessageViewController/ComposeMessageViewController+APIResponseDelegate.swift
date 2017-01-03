//
//  ComposeMessageViewController+APIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import WarmshowersData

extension ComposeMessageViewController: APIResponseDelegate {
    
    func requestDidComplete(_ request: APIRequest) {
        ProgressHUD.hide(navigationController?.view)
    }
    
    func request(_ request: APIRequest, didSucceedWithData data: Any?) {
        switch request.endPointType {
        case .newMessage:
            delegate?.composeMessageViewControllerDidSendANewMessage(self)
        case .replyToMessage:
            guard let reply = request.data as? ReplyMessageData else { break }
            delegate?.composeMessageViewController(self, didReplyOnThreadWithThreadID: reply.threadID)
        default:
            break
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    func request(_ request: APIRequest, didFailWithError error: Error) {
        alert.presentAPIError(error, forDelegator: self)
    }

}
