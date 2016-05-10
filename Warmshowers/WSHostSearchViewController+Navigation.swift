//
//  WSHostSearchViewController+NSSeguePerforming.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CCHMapClusterController

//extension WSHostSearchViewController {
//    
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        
//        switch identifier {
//            
//        case MapToUserAccountSegueID:
//            
//            return sender as? WSUserLocation != nil
//            
//        case ResultsToUserAccountSegueID:
//            
//            if let cell = sender as? HostListTableViewCell {
//                return cell.uid != nil
//            }
//            return false
//            
//        case ToHostListSegueID:
//            
//            if let clusterAnnotation = sender as? CCHMapClusterAnnotation {
//                return Array(clusterAnnotation.annotations) as? [WSUserLocation] != nil
//            }
//            return false
//            
//        default:
//            return true
//        }
//    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        switch segue.identifier! {
//            
//        case MapToUserAccountSegueID:
//            
//            let navVC = segue.destinationViewController as! UINavigationController
//            let accountTVC = navVC.viewControllers.first as! WSAccountTableViewController
//            
//            if let user = sender as? WSUserLocation {
//                accountTVC.uid = user.uid
//            } else {
//                accountTVC.uid = session.uid
//            }
//            
//        case ResultsToUserAccountSegueID:
//            
//            let navVC = segue.destinationViewController as! UINavigationController
//            let accountTVC = navVC.viewControllers.first as! WSAccountTableViewController
//            
//            if let cell = sender as? HostListTableViewCell {
//                accountTVC.uid = cell.uid
//            }
//            
//        case ToHostListSegueID:
//            
//            let navVC = segue.destinationViewController as! UINavigationController
//            let hostListTVC = navVC.viewControllers.first as! WSHostListTableViewController
//            
//            if let clusterAnnotation = sender as? CCHMapClusterAnnotation {
//                if let users = Array(clusterAnnotation.annotations) as? [WSUserLocation] {
//                    hostListTVC.lazyImageObjects = users
//                    hostListTVC.placeholderImageName = "ThumbnailPlaceholder"
//                }
//            }
//            
//        default:
//            return
//        }
//    }
//}