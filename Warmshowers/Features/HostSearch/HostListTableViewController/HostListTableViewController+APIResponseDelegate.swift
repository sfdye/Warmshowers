//
//  HostListTableViewController+APIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import WarmshowersData

extension HostListTableViewController: APIResponseDelegate {
    
    func requestDidComplete(_ request: APIRequest) {
        ProgressHUD.hide(navigationController?.view)
    }
    
    func request(_ request: APIRequest, didSucceedWithData data: Any?) {
        switch request.endPointType {
        case .imageResource:
            guard
                let imageURL = request.parameters as? String,
                let image = data as? UIImage
                else { return }
            setImage(image, forHostWithImageURL: imageURL)
        case .user:
            guard let host = data as? User else { return }
            DispatchQueue.main.async(execute: { 
                self.performSegue(withIdentifier: SID_HostListToUserAccount, sender: host)
            })
        default:
            break
        }
    }
    
    func request(_ request: APIRequest, didFailWithError error: Error) {
        switch request.endPointType {
        case .imageResource:
            // No need for action.
            break
        case .user:
            alert.presentAlertFor(self, withTitle: "Error", button: "OK", message: "Failed to get user info.")
        default:
            break
        }
    }
}
