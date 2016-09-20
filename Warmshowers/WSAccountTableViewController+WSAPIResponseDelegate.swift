//
//  WSAccountTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSAccountTableViewController: WSAPIResponseDelegate {
    
    func requestDidComplete(_ request: WSAPIRequest) {
        WSProgressHUD.hide(self.navigationController?.view)
    }
    
    func request(_ request: WSAPIRequest, didSuceedWithData data: Any?) {
        switch request.endPoint.type {
        case .ImageResource:
            guard let image = data as? UIImage else { return }
            user?.profileImage = image
            DispatchQueue.main.async(execute: { [weak self] in
                let indexPath = IndexPath(row: 0, section: 0)
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            })
        case .UserFeedback:
            guard let feedback = data as? [WSRecommendation] else { return }
            user?.feedback = feedback
            DispatchQueue.main.async(execute: { [weak self] in
                let indexPath = IndexPath(row: 0, section: 2)
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                })
        case .Logout:
            session.didLogoutFromView(self)
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
                        session.didLogoutFromView(self)
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
