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
        WSProgressHUD.hide()
        let username = usernameTextField.text, password = passwordTextField.text
        do {
            try sessionState?.savePassword(password!, forUsername: username!)
            navigationDelegate?.showMainApp()
        } catch {
            // This case is very unlikely.
            alertDelegate?.presentAlertFor(self, withTitle: "App error", button: "Sorry, an error occured while saving your username. Please report this as a bug, sorry for the inconvenience.")
        }
    }
    
    func didRecieveAPIFailureResponse(error: ErrorType) {
        WSProgressHUD.hide()
        
        var title: String?
        var message: String?
        
        switch error {
        case WSAPICommunicatorError.ServerError(let statusCode):
            if statusCode == 401 {
                title = "Login error"
                message = "Incorrect username or password."
            }
        default:
            title = "An unknown error occured"
            message = "Please try login again."
        }
        
        alertDelegate?.presentAlertFor(self, withTitle: title, button: "Dismiss", message: message)
    }
}
