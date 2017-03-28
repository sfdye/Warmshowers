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
        let title = NSLocalizedString("Error", comment: "General error alert title")
        let button = NSLocalizedString("OK", comment: "OK button title")
        let message = NSLocalizedString("Failed to get user info.", tableName: "HostSearch", comment: "The alert message shown when there was an error retrieving a hosts info from the API")
        alert.presentAlertFor(self, withTitle: title, button: button, message: message)
    }
    
}
