//
//  WSHostSearchViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSHostSearchViewController: WSAPIResponseDelegate {
    
    func requestDidComplete(request: WSAPIRequest) {
        WSProgressHUD.hide()
    }
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        guard let host = data as? WSUser else { return }
        dispatch_async(dispatch_get_main_queue()) { 
            self.performSegueWithIdentifier(SID_SearchViewToUserAccount, sender: host)
        }
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        alert.presentAlertFor(self, withTitle: "Error", button: "OK", message: "Failed to get user info.")
    }
    
}
