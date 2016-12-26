//
//  LoginViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension LoginViewController {
    
    /**
     Method called when the login button on the login page is pressed.
     */
    @IBAction func loginButton(_: UIButton) {
        
        // Resign the keyboard
        self.view.endEditing(true)
        
        guard let username = usernameTextField.text , username != "" else {
            alert.presentAlertFor(self, withTitle: "Missing Username", button: "Dismiss", message: "Please enter your username or email", andHandler: { [weak self] (action) in
                self?.usernameTextField.becomeFirstResponder()
                })
            return
        }
        
        guard let password = passwordTextField.text , password != "" else {
            alert.presentAlertFor(self, withTitle: "Missing Password", button: "Dismiss", message: "Please enter your password", andHandler: { [weak self] (action) in
                self?.passwordTextField.becomeFirstResponder()
                })
            return
        }
        
        // Show the spinner
        ProgressHUD.show("Logging in ...")
        
        // Login
        let loginData = LoginData(username: username, password: password)
        api.contact(endPoint: .Login, withPathParameters: nil, andData: loginData, thenNotify: self)
    }
    
    /**
     Method to take the user to the Warmshowers sign up page when the 'create account' button is pressed.
     */
    @IBAction func createAccountButtonPressed(_: UIButton) {
        let url = URL(string: "https://www.warmshowers.org/user/register")!
        navigation.open(url: url, fromViewController: self)
    }
    
}
