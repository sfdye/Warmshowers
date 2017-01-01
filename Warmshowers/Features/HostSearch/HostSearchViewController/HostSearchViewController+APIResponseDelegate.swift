//
//  HostSearchViewController+APIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import WarmshowersData

extension HostSearchViewController: APIResponseDelegate {
    
    func requestDidComplete(_ request: APIRequest) {
        ProgressHUD.hide()
    }
    
    func request(_ request: APIRequest, didSucceedWithData data: Any?) {
        guard let host = data as? User else { return }
        DispatchQueue.main.async { 
            self.performSegue(withIdentifier: SID_SearchViewToUserAccount, sender: host)
        }
    }
    
    func request(_ request: APIRequest, didFailWithError error: Error) {
        print(error)
        alert.presentAlertFor(self, withTitle: "Error", button: "OK", message: "Failed to get user info.")
    }
    
}
