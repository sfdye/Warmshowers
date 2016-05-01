//
//  WSHostSearchViewController+WSHostSearchControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSHostSearchViewController : WSHostSearchControllerDelegate {
    
    func locationSearchWillBeginUpdates() {
        dispatch_async(dispatch_get_main_queue()) { [weak self] () -> Void in
            self?.infoLabel.text = "Updating ..."
        }
    }
    
    func locationSearchDidFinishUpdates() {
        dispatch_async(dispatch_get_main_queue()) { [weak self] () -> Void in
            self?.infoLabel.text = nil
        }
    }
    
    func showProfileForUserAtLocation(location: WSUserLocation) {
        
    }
    
    func showHostListWithUsers(users: [WSUserLocation]) {
        
    }
}