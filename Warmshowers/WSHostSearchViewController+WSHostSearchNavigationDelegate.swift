//
//  WSHostSearchViewController+WSHostSearchNavigationDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSHostSearchViewController: WSHostSearchNavigationDelegate {
    
    func showUserProfileForHostWithUID(_ uid: Int) {
        WSProgressHUD.show(nil)
        api.contact(endPoint: .UserInfo, withPathParameters: String(uid) as NSString, andData: nil, thenNotify: self)
    }
    
    func showHostListWithHosts(_ hosts: [WSUserLocation]) {
        DispatchQueue.main.async { 
            self.performSegue(withIdentifier: SID_MapToHostList, sender: hosts)
        }
    }
    
}
