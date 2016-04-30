//
//  WSHostSearchViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSHostSearchViewController : WSAPIResponseDelegate {
    
    func didRecieveAPISuccessResponse(data: AnyObject?) {
        if data is [WSUserLocation] {
            reloadTableWithHosts(data as! [WSUserLocation])
        }
    }
    
    func didRecieveAPIFailureResponse(error: ErrorType) {
        alertDelegate?.presentAlertFor(self, withTitle: "Error", button: "Dismiss", message: nil)
    }
}
