//
//  WSHostSearchViewController+WSHostSearchNavigationDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSHostSearchViewController: WSHostSearchNavigationDelegate {
    
    func showUserProfileForHostWithUID(uid: Int) {
        WSProgressHUD.show(nil)
        api.contactEndPoint(.UserInfo, withPathParameters: String(uid) as NSString, andData: nil, thenNotify: self)
    }
    
    func showHostListWithHosts(hosts: [WSUserLocation]) {
        performSegueWithIdentifier(SID_MapToHostList, sender: hosts)
    }
    
}
