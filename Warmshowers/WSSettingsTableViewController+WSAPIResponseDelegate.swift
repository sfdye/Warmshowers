//
//  WSSettingsTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSSettingsTableViewController : WSAPIResponseDelegate {
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        switch request.endPoint.type {
        case .Logout:
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
        default:
            break
        }
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        alert.presentAlertFor(self, withTitle: "Logout failed", button: "Dismiss", message: "Please try again.")
    }
}