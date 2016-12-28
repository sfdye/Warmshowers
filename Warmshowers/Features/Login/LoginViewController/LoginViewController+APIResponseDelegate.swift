//
//  LoginViewController+APIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import WarmshowersData

extension LoginViewController: APIResponseDelegate {
    
    func request(_ request: APIRequest, didSucceedWithData data: Any?) {
        
        // Recieved login response: request a token
        if request.endPointType == .login {
            
            guard let uid = data as? Int else {
                alert.presentAlertFor(self, withTitle: "App error", button: "OK", message: "Sorry, an error occured during login. Please report this as a bug, sorry for the inconvenience.")
                return
            }
            
            session.save(uid: uid)
            
            api.contact(endPoint: .token, withMethod: .get, andPathParameters: nil, andData: nil, thenNotify: self)
            return
        }
        
        // Recieved the access token: proceed to the main app
        ProgressHUD.hide()
        let username = usernameTextField.text, password = passwordTextField.text
        do {
            try session.save(password: password!, forUsername: username!)
            navigation.showMainApp()
        } catch {
            // This case is very unlikely.
            alert.presentAlertFor(self, withTitle: "App error", button: "OK", message: "Sorry, an error occured during login. Please report this as a bug, sorry for the inconvenience.")
        }
    }
    
    func request(_ request: APIRequest, didFailWithError error: Error) {
        ProgressHUD.hide()
        var title: String?
        var message: String?
        
        switch error {
        case APICommunicatorError.serverError(let statusCode, _):
            if statusCode == 401 {
                title = "Login error"
                message = "Incorrect username or password."
            }
        default:
            title = "An unknown error occured"
            message = "Please try login again."
        }
        
        alert.presentAlertFor(self, withTitle: title, button: "Dismiss", message: message)
    }
}
