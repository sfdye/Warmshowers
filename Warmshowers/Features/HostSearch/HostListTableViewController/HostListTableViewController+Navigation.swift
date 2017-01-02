//
//  HostListTableViewController+Navigation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 11/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import WarmshowersData

extension HostListTableViewController {
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return sender is User
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let uid = sender as? Int else { return }
        let userProfileTVC = segue.destination as! UserProfileTableViewController
        userProfileTVC.uid = uid
    }
    
}
