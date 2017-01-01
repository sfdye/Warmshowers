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
            alert.presentAlertFor(self, withTitle: "You are currently offline", button: "OK")
            return
        }
        
        if let uid = session.uid, uid != 0 {
            showUserProfileForHostWithUID(uid)
        } else {
            alert.presentAlertFor(self, withTitle: "Error", button: "Sorry, this request could not be made. Please try logging out and back in again.")
        }
    }
    
}
