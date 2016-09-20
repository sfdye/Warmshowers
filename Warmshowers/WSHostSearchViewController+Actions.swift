//
//  WSHostSearchViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostSearchViewController {
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem?) {
        if !searchController.isActive && connection.isOnline {
            DispatchQueue.main.async {
                self.present(self.searchController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func accountButtonPressed(_ sender: UIBarButtonItem?) {
        
        guard connection.isOnline else {
            alert.presentAlertFor(self, withTitle: "You are currently offline", button: "OK")
            return
        }
        
        if let uid = session.uid {
            showUserProfileForHostWithUID(uid)
        }
    }
    
}
