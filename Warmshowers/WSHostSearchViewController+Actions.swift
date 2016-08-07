//
//  WSHostSearchViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostSearchViewController {
    
    @IBAction func searchButtonPressed(sender: UIBarButtonItem?) {
        if !searchController.active {
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(self.searchController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func accountButtonPressed(sender: UIBarButtonItem?) {
        if let uid = session.uid {
            showUserProfileForHostWithUID(uid)
        }
    }
    
}