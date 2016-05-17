//
//  WSLocationSearchViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 11/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSLocationSearchViewController : WSAPIResponseDelegate {
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        print("recieved host locations")
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        alertDelegate.presentAPIError(error, forDelegator: self)
    }
}
