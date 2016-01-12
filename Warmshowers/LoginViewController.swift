//
//  LoginViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    // Login text fields
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Reference to the app delegate for changing views after login
    weak var appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    // A http client for making the login request
    let httpRequest = WSRequest()
    
    // Alert controller to display errors
    var alertController: UIAlertController?
    
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the http client delegate for error alerts
        httpRequest.alertViewController = self
        
        // load the default username
        let defaults = NSUserDefaults.standardUserDefaults()
        if let username = defaults.objectForKey(DEFAULTS_KEY_USERNAME) {
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
        
        // log in
        httpRequest.login(username, password: password) { (success) -> Void in
            if success {
                
                // login sucessful, store the username and session cookie for later
                self.storeUsername()
                self.storePassword()
                // switch the root view controller to the tabbar view controller
                dispatch_async(dispatch_get_main_queue(), {
                    self.appDelegate?.showMainApp()
                })
                
            }
            // else: error will be displayed by the http client
        }
    }
    
    // MARK: - Utility functions
    
    func storeUsername() {
        let defaults = appDelegate!.defaults
        defaults.setValue(usernameTextField.text, forKey: DEFAULTS_KEY_USERNAME)
        defaults.synchronize()
    }
    
    func storePassword() {
        let defaults = appDelegate!.defaults
        defaults.setValue(passwordTextField.text, forKey: DEFAULTS_KEY_PASSWORD)
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

}
