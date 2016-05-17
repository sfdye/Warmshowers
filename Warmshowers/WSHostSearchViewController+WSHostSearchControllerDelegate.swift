//
//  WSHostSearchViewController+WSHostSearchControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostSearchViewController : WSHostSearchControllerDelegate {
    
    func presentErrorAlertWithError(error: ErrorType) {
        let delegator: UIViewController = searchController.active ? searchController : self
        print(delegator)
        alertDelegate.presentAPIError(error, forDelegator: delegator)
    }
    
//    func showAlertWithTitle(title: String, andMessage message: String?) {
//        alertDelegate.presentAlertFor(self, withTitle: title, button: "OK", message: message)
//    }
//    
//    func showProfileForUserAtLocation(location: WSUserLocation) {
//        
//    }
//    
//    func showHostListWithUsers(users: [WSUserLocation]) {
//        
//    }
}