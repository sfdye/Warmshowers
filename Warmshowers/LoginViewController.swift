//
//  LoginViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    // Login text fields
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    // Reference to the app delegate for changing views after login
    weak var appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    // Alert controller to display errors
    var alertController: UIAlertController?
    
    // Login manager
    var loginManager: WSLoginManager!


    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the default username
        usernameTextField.text = WSLoginData.username
        
        // Set up the login manager
        loginManager = WSLoginManager(
            success: {
                dispatch_async(dispatch_get_main_queue(), {
                    WSProgressHUD.hide()
                    (UIApplication.sharedApplication().delegate as! AppDelegate).showMainApp()
                })
            },
            failure: { (error) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    WSProgressHUD.hide()
                    self.alert("Login failed", message: error.localizedDescription)
                })
            }
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButton(sender: UIButton) {
        
        // resign the keyboard
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
        do {
            try WSLoginData.saveCredentials(password, forUsername: username)
            loginManager.login()
        } catch {
            // Serious error. Autologin will not be possible later.
            abort()
        }
    }
    
    // Method to take the user to the Warmshowers sign up page when the 'create account' button is pressed
    //
    @IBAction func createAccountButtonPressed(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.warmshowers.org/user/register")!)
    }
    
    // MARK: - Utility functions
    
    // Shows an alert with a 'Dismiss' button
    //
    func alert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        
        guard alertController == nil else {
            return
        }
        
        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController!.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(self.alertController!, animated: true, completion: { () -> Void in self.alertController = nil})
        })
    }

}
