//
//  UserProfileTableViewController+APIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import WarmshowersData

extension UserProfileTableViewController: APIResponseDelegate {
    
    func requestDidComplete(_ request: APIRequest) {
        ProgressHUD.hide(self.navigationController?.view)
    }
    
    func request(_ request: APIRequest, didSucceedWithData data: Any?) {
        switch request.endPointType {
        case .user:
            guard let user = data as? User else { return }
            self.user = user
            
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
            
            // Download the users feedback.
            api.contact(endPoint: .feedback, withMethod: .get, andPathParameters: uid, andData: nil, thenNotify: self)
            
            // Get the users profile image if they have one.
            if user.profileImage == nil && user.profileImageURL != nil {
                api.contact(endPoint: .imageResource, withMethod: .get, andPathParameters: user.profileImageURL, andData: nil, thenNotify: self)
            }
            
        case .imageResource:
            guard let image = data as? UIImage else { return }
            user?.profileImage = image
            DispatchQueue.main.async(execute: { [weak self] in
                let indexPath = IndexPath(row: 0, section: 0)
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            })
        case .feedback:
            guard let feedback = data as? [Recommendation] else { return }
            user?.feedback = feedback
            DispatchQueue.main.async(execute: { [weak self] in
                let indexPath = IndexPath(row: 0, section: 2)
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                })
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
