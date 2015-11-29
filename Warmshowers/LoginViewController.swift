//
//  LoginViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

let USERNAME = "ws_username"
let PASSWORD = "ws_password"

class LoginViewController: UIViewController, WSRequestAlert {
    
    // MARK: Properties
    
    // Login text fields
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Reference to the app delegate for changing views after login
    weak var appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    
    // A http client for making the login request
    let httpClient = WSRequest()
    
    // An alert controller to display errors
    var alertController: UIAlertController?
    
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the http client delegate for error alerts
        httpClient.alertViewController = self
        
        // load the default username
        let defaults = NSUserDefaults.standardUserDefaults()
        if let username = defaults.objectForKey(USERNAME) {
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
        httpClient.login(username, password: password) { (success) -> Void in
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
        defaults.setValue(usernameTextField.text, forKey: USERNAME)
        defaults.synchronize()
    }
    
    func storePassword() {
        defaults.setValue(passwordTextField.text, forKey: PASSWORD)
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
    
    // MARK: - WSRequestAlert Delegate functions
    
    func requestAlert(title: String, message: String) {
        
        guard alertController == nil else {
            return
        }

        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        if alertController != nil {
            alertController!.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController!, animated: true, completion: { () -> Void in self.alertController = nil})
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
