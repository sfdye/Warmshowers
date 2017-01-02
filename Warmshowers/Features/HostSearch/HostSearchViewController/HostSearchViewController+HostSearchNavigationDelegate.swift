//
//  HostSearchViewController+HostSearchNavigationDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import WarmshowersData

extension HostSearchViewController: HostSearchNavigationDelegate {
    
    func showUserProfileForHostWithUID(_ uid: Int) {
        self.performSegue(withIdentifier: SID_SearchViewToUserAccount, sender: uid)
    }
    
    func showHostListWithHosts(_ hosts: [UserLocation]) {
        DispatchQueue.main.async { 
            self.performSegue(withIdentifier: SID_MapToHostList, sender: hosts)
        }
    }
    
}
