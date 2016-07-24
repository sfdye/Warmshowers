//
//  WSAccountTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSAccountTableViewController: WSAPIResponseDelegate {
    
    func requestDidComplete(request: WSAPIRequest) {
        WSProgressHUD.hide(self.navigationController!.view)
    }
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        switch request.endPoint.type {
        case .ImageResource:
            guard let image = data as? UIImage else { return }
            user?.profileImage = image
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                self?.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })
        case .UserFeedback:
            guard let feedback = data as? [WSRecommendation] else { return }
            user?.feedback = feedback
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                let indexPath = NSIndexPath(forRow: 0, inSection: 2)
                self?.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                })
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
            if nserror.code == 4 {
                // WSAPICommunicatorError.ServerError. This is usually a 406: user already logged out.
                logout()
            } else {
                alert.presentAlertFor(self, withTitle: "Logout failed", button: "Dismiss", message: "Please try again.")
            }
        default:
            break
        }
    }
    
    func logout() {
        do {
            session.deleteSessionData()
            try store.clearout()
            navigation.showLoginScreen()
        } catch {
            // Suggest that the user delete the app for privacy.
            alert.presentAlertFor(self, withTitle: "Data Error", button: "OK", message: "Sorry, an error occured while removing your account data from this iPhone. If you would like to remove your Warmshowers messages from this iPhone please try deleting the Warmshowers app.", andHandler: { [weak self] (action) in
                self?.navigation.showLoginScreen()
                })
        }
    }

}