//
//  HostSearchViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension HostSearchViewController: APIResponseDelegate {
    
    func requestDidComplete(_ request: APIRequest) {
        ProgressHUD.hide()
    }
    
    func request(_ request: APIRequest, didSuceedWithData data: Any?) {
        guard let host = data as? User else { return }
        DispatchQueue.main.async { 
            self.performSegue(withIdentifier: SID_SearchViewToUserAccount, sender: host)
        }
    }
    
    func request(_ request: APIRequest, didFailWithError error: Error) {
        alert.presentAlertFor(self, withTitle: "Error", button: "OK", message: "Failed to get user info.")
    }
    
}
