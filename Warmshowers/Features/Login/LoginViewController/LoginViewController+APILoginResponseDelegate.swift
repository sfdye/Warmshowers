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
            alert.presentAlertFor(self, withTitle: "App error", button: "OK", message: "Sorry, an error occured during login. Please report this as a bug, sorry for the inconvenience.")
        }
    }
    
    func loginRequest(_ loginRequest: APILoginRequest, didFailWithError error: Error) {
        
        ProgressHUD.hide()
        var title: String?
        var message: String?
        
        switch error {
        case is APILoginError:
            title = "Login error"
            message = "Incorrect username or password."
        default:
            title = "An unknown error occured"
            message = "Please try login again."
        }
        
        alert.presentAlertFor(self, withTitle: title, button: "Dismiss", message: message)
    }

}
