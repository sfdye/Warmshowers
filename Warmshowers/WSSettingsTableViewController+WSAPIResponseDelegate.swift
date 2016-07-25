//
//  WSSettingsTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSSettingsTableViewController : WSAPIResponseDelegate {
    
    func requestDidComplete(request: WSAPIRequest) {
        WSProgressHUD.hide()
    }
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        switch request.endPoint.type {
        case .Logout:
            logout()
        default:
            break
        }
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        switch request.endPoint.type {
        case .Logout:
            let nserror = error as NSError
            // WSAPICommunicatorError.ServerError. This is usually a 406: user already logged out.
            if nserror.code == 4 {
                logout()
            } else {
                alert.presentAlertFor(self, withTitle: "Logout failed", button: "Dismiss", message: "Please try again.")
            }
        default:
            break
        }
    }
    
}