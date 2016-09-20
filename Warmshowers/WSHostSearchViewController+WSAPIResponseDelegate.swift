//
//  WSHostSearchViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSHostSearchViewController: WSAPIResponseDelegate {
    
    func requestDidComplete(_ request: WSAPIRequest) {
        WSProgressHUD.hide()
    }
    
    func request(_ request: WSAPIRequest, didSuceedWithData data: Any?) {
        guard let host = data as? WSUser else { return }
        DispatchQueue.main.async { 
            self.performSegue(withIdentifier: SID_SearchViewToUserAccount, sender: host)
        }
    }
    
    func request(_ request: WSAPIRequest, didFailWithError error: Error) {
        alert.presentAlertFor(self, withTitle: "Error", button: "OK", message: "Failed to get user info.")
    }
    
}
