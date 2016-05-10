//
//  WSHostSearchControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

@objc protocol WSHostSearchControllerDelegate {
    
    /** Presents a simple OK alert */
    func showAlertWithTitle(title: String, andMessage: String?)
    
    /** Initiates a segue to show the account/profile screen for a given user */
    func showProfileForUserAtLocation(location: WSUserLocation)
    
    /** Initiates a segue to show a list of users */
    func showHostListWithUsers(users: [WSUserLocation])
}