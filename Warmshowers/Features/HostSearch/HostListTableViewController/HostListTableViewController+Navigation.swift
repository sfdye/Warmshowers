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
        guard sender is User else { return }
        let accountTVC = segue.destination as! UserProfileTableViewController
        accountTVC.user = sender as? User
    }
    
}
