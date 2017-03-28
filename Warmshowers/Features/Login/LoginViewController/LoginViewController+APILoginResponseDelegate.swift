//
//  LoginViewController+APILoginResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import WarmshowersData

extension LoginViewController: APILoginResponseDelegate {
    
    func loginRequestDidSucceed(_ loginRequest: APILoginRequest) {
        
        session.save(uid: loginRequest.uid)
        
        ProgressHUD.hide()
        do {
            try secureStore.save(username: loginRequest.username, andPassword: loginRequest.password)
            navigation.showMainApp()
        } catch {
            // This case is very unlikely.
            let title = NSLocalizedString("Error", comment: "General error alert title")
            let message = NSLocalizedString("Sorry, an error occured during login. Please report this as a bug, sorry for the inconvenience.", comment: "Alert message for generic app error.")
            let buttonTitle = NSLocalizedString("OK", comment: "OK button title")
            alert.presentAlertFor(self, withTitle: title, button: buttonTitle, message: message)
        }
    }
    
    func loginRequest(_ loginRequest: APILoginRequest, didFailWithError error: Error) {
        
        ProgressHUD.hide()
        var title: String?
        var message: String?
        
        switch error {
        case is APILoginError:
            title = NSLocalizedString("Login error", tableName: "Login", comment: "Alert title for a known login error.")
            message = NSLocalizedString("Incorrect username or password.", tableName: "Login", comment: "Alert message for a known login error.")
        default:
            title = NSLocalizedString("An unknown error occured", tableName: "Login", comment: "Alert title for an unknown login error.")
            message = NSLocalizedString("Please try login again.", tableName: "Login", comment: "Alert message for an unknown login error.")
        }
        
        let buttonTitle = NSLocalizedString("Dismiss", comment: "Dismiss button title")
        alert.presentAlertFor(self, withTitle: title, button: buttonTitle, message: message)
    }

}
