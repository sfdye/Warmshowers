//
//  HostSearchViewController+NSSeguePerforming.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CCHMapClusterController
import WarmshowersData

let SID_MapToUserAccount = "MapToUserAccount"
let SID_MapToHostList = "MapToHostList"
let SIB_ResultsToUserAccount = "SearchResultsToUserAccount"

extension HostSearchViewController {
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        switch identifier {
            
        case SID_SearchViewToUserAccount:
            
            return sender is User
            
        case SID_MapToHostList:
            
            return sender is [UserLocation]
            
        default:
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueIdentifier = segue.identifier else { return }
        
        switch segueIdentifier {
            
        case SID_SearchViewToUserAccount:
            
            guard sender is User else { return }
            let navVC = segue.destination as! UINavigationController
            let accountTVC = navVC.viewControllers.first as! UserProfileTableViewController
            accountTVC.user = sender as? User
            
        case SID_MapToHostList:
            
            let navVC = segue.destination as! UINavigationController
            let hostListTVC = navVC.viewControllers.first as! HostListTableViewController
            hostListTVC.hosts = sender as? [UserLocation]
            
        default:
            return
        }
    }
}
