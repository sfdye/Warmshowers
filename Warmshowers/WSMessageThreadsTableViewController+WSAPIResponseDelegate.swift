//
//  WSMessageThreadsTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSMessageThreadsTableViewController : WSAPIResponseDelegate {
    
    func request(_ request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        
    }
    
    func request(_ request: WSAPIRequest, didFailWithError error: ErrorProtocol) {
        alertDelegate.presentAPIError(error, forDelegator: self)
    }
    
}
