//
//  WSKeywordSearchTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSKeywordSearchTableViewController : WSAPIResponseDelegate {
    
    func didRecieveAPISuccessResponse(data: AnyObject?) {
        if data is [WSUserLocation] {
            reloadTableWithHosts(data as! [WSUserLocation])
        }
    }
    
    func didRecieveAPIFailureResponse(error: ErrorType) {
        reloadTableWithHosts([WSUserLocation]())
    }
}
