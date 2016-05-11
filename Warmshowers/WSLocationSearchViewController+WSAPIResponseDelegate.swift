//
//  WSLocationSearchViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 11/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSLocationSearchViewController : WSAPIResponseDelegate {
    
    func didRecieveAPISuccessResponse(data: AnyObject?) {
        print("recieved host locations")
    }
    
    func didRecieveAPIFailureResponse(error: ErrorType) {
        alertDelegate.presentAPIError(error, forDelegator: self)
    }
}
