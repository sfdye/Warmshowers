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
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: MessagesViewNeedsUpdateNotificationName), object: nil))
        DispatchQueue.main.async(execute: { () -> Void in
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    func request(_ request: APIRequest, didFailWithError error: Error) {
        alert.presentAPIError(error, forDelegator: self)
    }

}
