//
//  WSLoginViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSLoginViewController : WSAPIResponseDelegate {
    
    func request(_ request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        if data is String {
            // Recieved the access token: proceed to the main app
            WSProgressHUD.hide()
            let username = usernameTextField.text, password = passwordTextField.text
            do {
                try sessionState?.savePassword(password!, forUsername: username!)
                navigationDelegate?.showMainApp()
            } catch {
                // This case is very unlikely.
                alertDelegate?.presentAlertFor(self, withTitle: "App error", button: "Sorry, an error occured while saving your username. Please report this as a bug, sorry for the inconvenience.")
            }
        } else {
            // Recieved login response: request a token
            print("back in login controller: getting toke.")
            apiCommunicator?.getTokenAndNotify(self)
        }
    }
    
    func request(_ request: WSAPIRequest, didFailWithError error: ErrorProtocol) {
        WSProgressHUD.hide()
        
        var title: String?
        var message: String?
        
        switch error {
        case WSAPICommunicatorError.serverError(let statusCode, _):
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
