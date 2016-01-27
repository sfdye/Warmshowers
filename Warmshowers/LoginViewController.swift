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
    

    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load the default username
        let defaults = NSUserDefaults.standardUserDefaults()
        if let username = defaults.objectForKey(defaults_key_username) {
            usernameTextField.text = username as? String
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButton(sender: UIButton) {
        
        // resign the keyboard
        self.view.endEditing(true)
        
        // check and get input
        if usernameTextField.text == nil || usernameTextField.text == "" {
            self.alert("Missing Username", message: "Please enter your username or email", handler: {action -> () in
                self.usernameTextField.becomeFirstResponder()
            })
            return
        } else if passwordTextField.text == nil || passwordTextField.text == ""{
            self.alert("Missing Password", message: "Please enter your password", handler: {action -> () in
                self.passwordTextField.becomeFirstResponder()
            })
            return
        }
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        // Show the spinner
        showHUD()
        
        // log in
        WSRequest.login(username, password: password) { (success, response, error) -> Void in
            
            // Remove the spinner
            self.hideHUD()
            
            if success {
                
                // Login sucessful: store the username and session cookie for later
                self.storeUsername()
                self.storePassword()
                // switch the root view controller to the tabbar view controller
                dispatch_async(dispatch_get_main_queue(), {
                    self.appDelegate?.showMainApp()
                })
                
            } else {
                
                let alert: UIAlertController
                let message: String
                
                if let error = error {
                    message  = error.localizedDescription
                } else if let response = response as? NSHTTPURLResponse where response.statusCode == 401 {
                    message = "Please check your username and password are correct"
                } else {
                    message = "Please check that your username and password are correct, and that you are connected to the internet"
                }
                
                // Login failed: show an error message
                alert = UIAlertController(title: "Login failed", message: message, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(okAction)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
    }
    
    // Method to take the user to the Warmshowers sign up page when the 'create account' button is pressed
    //
    @IBAction func createAccountButtonPressed(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.warmshowers.org/user/register")!)
    }
    
    // MARK: - Utility functions
    
    func storeUsername() {
        let defaults = appDelegate!.defaults
        defaults.setValue(usernameTextField.text, forKey: defaults_key_username)
        defaults.synchronize()
    }
    
    func storePassword() {
        let defaults = appDelegate!.defaults
        defaults.setValue(passwordTextField.text, forKey: defaults_key_password)
        defaults.synchronize()
    }
    
    func alert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        
        guard alertController == nil else {
            return
        }
        
        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        if alertController != nil {
            alertController!.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController!, animated: true, completion: { () -> Void in self.alertController = nil})
        }
        
    }
    
    func showHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Logging in ..."
        hud.dimBackground = true
        hud.removeFromSuperViewOnHide = true
    }
    
    func hideHUD() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }

}
