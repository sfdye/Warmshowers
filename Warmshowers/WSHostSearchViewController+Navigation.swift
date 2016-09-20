//
//  WSHostSearchViewController+NSSeguePerforming.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CCHMapClusterController

let SID_MapToUserAccount = "MapToUserAccount"
let SID_MapToHostList = "MapToHostList"
let SIB_ResultsToUserAccount = "SearchResultsToUserAccount"

extension WSHostSearchViewController {
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        switch identifier {
            
        case SID_SearchViewToUserAccount:
            
            return sender is WSUser
            
        case SID_MapToHostList:
            
            return sender is [WSUserLocation]
            
        default:
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueIdentifier = segue.identifier else { return }
        
        switch segueIdentifier {
            
        case SID_SearchViewToUserAccount:
            
            guard sender is WSUser else { return }
            let navVC = segue.destination as! UINavigationController
            let accountTVC = navVC.viewControllers.first as! WSAccountTableViewController
            accountTVC.user = sender as? WSUser
            
        case SID_MapToHostList:
            
            let navVC = segue.destination as! UINavigationController
            let hostListTVC = navVC.viewControllers.first as! WSHostListTableViewController
            hostListTVC.hosts = sender as? [WSUserLocation]
            
        default:
            return
        }
    }
}
