//
//  WSHostListTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostListTableViewController : WSAPIResponseDelegate {
    
    func requestDidComplete(request: WSAPIRequest) {
        WSProgressHUD.hide(navigationController!.view)
    }
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        switch request.endPoint.type {
        case .ImageResource:
            guard
                let imageURL = request.parameters as? String,
                let image = data as? UIImage
                else { return }
            setImage(image, forHostWithImageURL: imageURL)
        case .UserInfo:
            guard let host = data as? WSUser else { return }
            dispatch_async(dispatch_get_main_queue(), { 
                self.performSegueWithIdentifier(SID_HostListToUserAccount, sender: host)
            })
        default:
            break
        }
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
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