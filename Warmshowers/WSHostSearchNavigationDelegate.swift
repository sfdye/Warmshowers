//
//  WSHostSearchNavigationDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSHostSearchNavigationDelegate {
    
    /** Segues to a user profile view for the given user. */
    func showUserProfileForHost(host: WSUserLocation)
    
    /** Segues to a list of hosts. */
    func showHostListWithHosts(hosts: [WSUserLocation])
    
}