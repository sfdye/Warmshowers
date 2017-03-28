//
//  HostSearchViewController+HostSearchControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension HostSearchViewController : HostSearchControllerDelegate {
    
    func presentErrorAlertWithError(_ error: Error) {
        alert.presentAPIError(error, forDelegator: self)
    }
    
}
