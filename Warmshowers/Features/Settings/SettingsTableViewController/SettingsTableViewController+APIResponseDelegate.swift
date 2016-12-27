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
                alert.presentAlertFor(self, withTitle: "Logout failed", button: "Dismiss", message: "Please try again.")
            }
        default:
            break
        }
    }
    
}
