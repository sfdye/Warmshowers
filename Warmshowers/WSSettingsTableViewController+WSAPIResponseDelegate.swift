//
//  WSSettingsTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSSettingsTableViewController : WSAPIResponseDelegate {
    
    func requestDidComplete(_ request: WSAPIRequest) {
        WSProgressHUD.hide()
    }
    
    func request(_ request: WSAPIRequest, didSuceedWithData data: Any?) {
        switch request.endPoint.type {
        case .Logout:
            session.didLogout(fromViewContoller: self)
        default:
            break
        }
    }
    
    func request(_ request: WSAPIRequest, didFailWithError error: Error) {
        switch request.endPoint.type {
        case .Logout:
            switch error {
            case is WSAPICommunicatorError:
                switch (error as! WSAPICommunicatorError) {
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
