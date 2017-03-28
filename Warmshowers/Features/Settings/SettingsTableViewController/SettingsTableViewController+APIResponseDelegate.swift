//
//  SettingsTableViewController+APIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import WarmshowersData

extension SettingsTableViewController : APIResponseDelegate {
    
    func requestDidComplete(_ request: APIRequest) {
        ProgressHUD.hide()
    }
    
    func request(_ request: APIRequest, didSucceedWithData data: Any?) {
        switch request.endPointType {
        case .logout:
            session.didLogout(fromViewContoller: self)
        default:
            break
        }
    }
    
    func request(_ request: APIRequest, didFailWithError error: Error) {
        switch request.endPointType {
        case .logout:
            switch error {
            case is APICommunicatorError:
                switch (error as! APICommunicatorError) {
                case .serverError(let statusCode, _):
                    if statusCode == 406 {
                        // 406: user already logged out.
                        session.didLogout(fromViewContoller: self)
                    }
                default:
                    break
                }
            default:
                let title = NSLocalizedString("Logout failed", tableName: "Settings", comment: "Title for the alert shown after a failed logout")
                let message = NSLocalizedString("Please try again.", tableName: "Settings", comment: "Message for the alert shown after a failed logout")
                let button = NSLocalizedString("Dismiss", comment: "Dismiss button title")
                alert.presentAlertFor(self, withTitle: title, button: button, message: message)
            }
        default:
            break
        }
    }
    
}
