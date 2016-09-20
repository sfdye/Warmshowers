//
//  WSHostListTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostListTableViewController : WSAPIResponseDelegate {
    
    func requestDidComplete(_ request: WSAPIRequest) {
        WSProgressHUD.hide(navigationController?.view)
    }
    
    func request(_ request: WSAPIRequest, didSuceedWithData data: Any?) {
        switch request.endPoint.type {
        case .ImageResource:
            guard
                let imageURL = request.parameters as? String,
                let image = data as? UIImage
                else { return }
            setImage(image, forHostWithImageURL: imageURL)
        case .UserInfo:
            guard let host = data as? WSUser else { return }
            DispatchQueue.main.async(execute: { 
                self.performSegue(withIdentifier: SID_HostListToUserAccount, sender: host)
            })
        default:
            break
        }
    }
    
    func request(_ request: WSAPIRequest, didFailWithError error: Error) {
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
