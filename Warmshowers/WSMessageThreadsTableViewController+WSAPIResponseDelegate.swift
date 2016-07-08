//
//  WSMessageThreadsTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSMessageThreadsTableViewController : WSAPIResponseDelegate {
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        alert.presentAPIError(error, forDelegator: self)
    }
    
}