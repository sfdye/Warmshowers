//
//  WSHostSearchViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSHostSearchViewController: WSAPIResponseDelegate {
    
    func requestdidComplete(request: WSAPIRequest) {
        WSProgressHUD.hide()
    }
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        guard let host = data as? WSUser else { return }
        performSegueWithIdentifier(SID_SearchViewToUserAccount, sender: host)
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        print(error)
        alert.presentAlertFor(self, withTitle: "Error", button: "OK", message: "Failed to get user info.")
    }
    
}
