//
//  HostListTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension HostListTableViewController : APIResponseDelegate {
    
    func requestDidComplete(_ request: APIRequest) {
        ProgressHUD.hide(navigationController?.view)
    }
    
    func request(_ request: APIRequest, didSuceedWithData data: Any?) {
        switch request.endPoint.type {
        case .ImageResource:
            guard
                let imageURL = request.parameters as? String,
                let image = data as? UIImage
                else { return }
            setImage(image, forHostWithImageURL: imageURL)
        case .UserInfo:
            guard let host = data as? User else { return }
            DispatchQueue.main.async(execute: { 
                self.performSegue(withIdentifier: SID_HostListToUserAccount, sender: host)
            })
        default:
            break
        }
    }
    
    func request(_ request: APIRequest, didFailWithError error: Error) {
        switch request.endPoint.type {
        case .ImageResource:
            // No need for action.
            break
        case .UserInfo:
            alert.presentAlertFor(self, withTitle: "Error", button: "OK", message: "Failed to get user info.")
        default:
            break
        }
    }
}
