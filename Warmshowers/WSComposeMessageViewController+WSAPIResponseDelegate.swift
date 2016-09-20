//
//  WSComposeMessageViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSComposeMessageViewController : WSAPIResponseDelegate {
    
    func requestDidComplete(_ request: WSAPIRequest) {
        WSProgressHUD.hide(navigationController?.view)
    }
    
    func request(_ request: WSAPIRequest, didSuceedWithData data: Any?) {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: MessagesViewNeedsUpdateNotificationName), object: nil))
        DispatchQueue.main.async(execute: { () -> Void in
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    func request(_ request: WSAPIRequest, didFailWithError error: Error) {
        alert.presentAPIError(error, forDelegator: self)
    }

}
