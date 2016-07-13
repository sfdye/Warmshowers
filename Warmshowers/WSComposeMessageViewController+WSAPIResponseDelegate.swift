//
//  WSComposeMessageViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSComposeMessageViewController : WSAPIResponseDelegate {
    
    func requestDidComplete(request: WSAPIRequest) {
        WSProgressHUD.hide(navigationController!.view)
    }
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        let notificationCentre = NSNotificationCenter.defaultCenter()
        notificationCentre.postNotification(NSNotification(name: MessagesViewNeedsUpdateNotificationName, object: nil))
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        alert.presentAPIError(error, forDelegator: self)
    }

}