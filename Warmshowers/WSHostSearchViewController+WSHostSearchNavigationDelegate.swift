//
//  WSHostSearchViewController+WSHostSearchNavigationDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSHostSearchViewController: WSHostSearchNavigationDelegate {
    
    func showUserProfileForHost(host: WSUserLocation) {
        performSegueWithIdentifier(SID_MapToUserAccount, sender: host)
    }
    
    func showHostListWithHosts(hosts: [WSUserLocation]) {
        performSegueWithIdentifier(SID_MapToHostList, sender: hosts)
    }
}
