//
//  LoginViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import WarmshowersData

extension LoginViewController {
    
    /**
     Method called when the login button on the login page is pressed.
     */
    @IBAction func loginButton(_: UIButton) {
        
        // Resign the keyboard
        self.view.endEditing(true)
        
        guard let username = usernameTextField.text , username != "" else {
            let title = NSLocalizedString("Missing Username", tableName: "Login", comment: "Alert title for a missing username at login.")
            let message = NSLocalizedString("Please enter your username or email", tableName: "Login", comment: "Alert message for a missing username at login.")
            let buttonTitle = NSLocalizedString("OK", comment: "OK button title")
            alert.presentAlertFor(self, withTitle: title, button: buttonTitle, message: message, andHandler: { [weak self] (action) in
                self?.usernameTextField.becomeFirstResponder()
                })
            return
        }
        
        session.set(username: username)
        
        guard let password = passwordTextField.text , password != "" else {
            let title = NSLocalizedString("Missing Password", tableName: "Login", comment: "Alert title for a missing password at login.")
            let message = NSLocalizedString("Please enter your password", tableName: "Login", comment: "Alert message for a missing password at login.")
            let buttonTitle = NSLocalizedString("OK", comment: "OK button title")
            alert.presentAlertFor(self, withTitle: title, button: buttonTitle, message: message, andHandler: { [weak self] (action) in
                self?.passwordTextField.becomeFirstResponder()
                })
            return
        }
        
        // Show the spinner
        let loginMessage = NSLocalizedString("Logging in ...", tableName: "Login", comment: "Message shown with the spinner during the login process.")
        ProgressHUD.show(loginMessage)
        
        // Login
        api.login.login(withUsername: username, andPassword: password, thenNotify: self)
    }
    
    /**
     Method to take the user to the Warmshowers sign up page when the 'create account' button is pressed.
     */
    @IBAction func createAccountButtonPressed(_: UIButton) {
        let url = URL(string: "https://www.warmshowers.org/user/register")!
        navigation.open(url: url, fromViewController: self)
    }
    
    @IBAction func backgroundTapped(_ sender: Any?) {
        DispatchQueue.main.async { [unowned self] in
            self.view.endEditing(false)
        }
    }
    
}
