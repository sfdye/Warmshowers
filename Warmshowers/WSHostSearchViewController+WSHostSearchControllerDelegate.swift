//
//  WSHostSearchViewController+WSHostSearchControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostSearchViewController : WSHostSearchControllerDelegate {
    
    func presentErrorAlertWithError(_ error: Error) {
//        let delegator: UIViewController = searchController.active ? searchController : self
        
        alert.presentAPIError(error, forDelegator: self) //delegator)
    }
    
}
