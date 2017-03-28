//
//  HostSearchViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension HostSearchViewController {
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem?) {
        if !searchController.isActive && api.connection.isOnline {
            DispatchQueue.main.async {
                self.present(self.searchController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func accountButtonPressed(_ sender: UIBarButtonItem?) {
        
        guard api.connection.isOnline else {
            let title = NSLocalizedString("You are currently offline", comment: "Title for an alert presented when the user makes a request but is offline")
            let button = NSLocalizedString("OK", comment: "OK button title")
            alert.presentAlertFor(self, withTitle: title, button: button)
            return
        }
        
        if let uid = session.uid, uid != 0 {
            showUserProfileForHostWithUID(uid)
        } else {
            let title = NSLocalizedString("Error", comment: "General error alert title")
            let button = NSLocalizedString("OK", comment: "OK button title")
            let message = NSLocalizedString("Sorry, this request could not be made. Please try logging out and back in again.", comment: "The alert message shown when the users account details can not be displayed, because the user ID for the API request is not knowm")
            alert.presentAlertFor(self, withTitle: title, button: button, message: message)
        }
    }
    
}
