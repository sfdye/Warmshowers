//
//  WSLoginViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSLoginViewController : WSAPIResponseDelegate {
    
    func didRecieveAPISuccessResponse(data: AnyObject?) {
        dispatch_async(dispatch_get_main_queue()) {
            WSProgressHUD.hide()
            (UIApplication.sharedApplication().delegate as! AppDelegate).showMainApp()
        }
    }
    
    func didRecieveAPIFailureResponse(error: ErrorType) {
        dispatch_async(dispatch_get_main_queue()) {
            WSProgressHUD.hide()
            switch error {
            case WSAPICommunicatorError.ServerError(let statusCode):
                if statusCode == 401 {
                    self.alert("Login error", message: "Incorrect username or password.")
                }
            default:
                self.alert("An unknown error occured", message: "Please try login again.")
            }
        }
    }
}
