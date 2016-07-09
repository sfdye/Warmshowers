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
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        switch identifier {
            
        case SID_MapToUserAccount:
            
            return sender is WSUserLocation
            
        case SIB_ResultsToUserAccount:
            
            if let cell = sender as? HostListTableViewCell {
                return cell.uid != nil
            }
            return false
            
        case SID_MapToHostList:
            
            return sender is [WSUserLocation]
            
        default:
            return true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let segueIdentifier = segue.identifier else { return }
        
        switch segueIdentifier {
            
        case SID_MapToUserAccount:
            
            let navVC = segue.destinationViewController as! UINavigationController
            let accountTVC = navVC.viewControllers.first as! WSAccountTableViewController
            
            if let user = sender as? WSUserLocation {
                accountTVC.uid = user.uid
            } else {
                accountTVC.uid = session.uid
            }
            
        case SIB_ResultsToUserAccount:
            
            let navVC = segue.destinationViewController as! UINavigationController
            let accountTVC = navVC.viewControllers.first as! WSAccountTableViewController
            
            if let cell = sender as? HostListTableViewCell {
                accountTVC.uid = cell.uid
            }
            
        case SID_MapToHostList:
            
            let navVC = segue.destinationViewController as! UINavigationController
            let hostListTVC = navVC.viewControllers.first as! WSHostListTableViewController
            hostListTVC.hosts = sender as? [WSUserLocation]
            
        default:
            return
        }
    }
}