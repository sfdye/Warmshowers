//
//  WSLoginViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSLoginViewController {
    
    /**
     Method called when the login button on the login page is pressed.
     */
    @IBAction func loginButton(sender: UIButton) {
        
        // Resign the keyboard
        self.view.endEditing(true)
        
        guard let username = usernameTextField.text where username != "" else {
            self.alert("Missing Username", message: "Please enter your username or email", handler: {action -> () in
                self.usernameTextField.becomeFirstResponder()
            })
            return
        }
        
        guard let password = passwordTextField.text where password != "" else {
            self.alert("Missing Password", message: "Please enter your password", handler: {action -> () in
                self.passwordTextField.becomeFirstResponder()
            })
            return
        }
        
        // Show the spinner
        WSProgressHUD.show("Logging in ...")
        
        // Login
        apiCommunicator?.login(username, password: password, andNotify: self)
        
//        do {
////            try WSSessionData.saveCredentials(password, forUsername: username)
//            apiCommunicator?.login
//        } catch {
//            // Serious error. Autologin will not be possible later.
//            abort()
//        }
    }
    
    /**
     Method to take the user to the Warmshowers sign up page when the 'create account' button is pressed.
     */
    @IBAction func createAccountButtonPressed(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.warmshowers.org/user/register")!)
    }
}