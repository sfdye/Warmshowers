//
//  WSHostSearchControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

protocol WSHostSearchControllerDelegate {
    
    var alertDelegate: WSAlertDelegate? { get }
    
    /** Called when the location search controller will begin updating hosts on the map */
    func locationSearchWillBeginUpdates()
    
    /** Called when the location search controller did finish updating hosts on the map */
    func locationSearchDidFinishUpdates()
    
    /** Initiates a segue to show the account/profile screen for a given user */
    func showProfileForUserAtLocation(location: WSUserLocation)
    
    /** Initiates a segue to show a list of users */
    func showHostListWithUsers(users: [WSUserLocation])
}