//
//  LoginViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, WSRequestAlert {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let httpClient = WSRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // load the default username
        let defaults = NSUserDefaults.standardUserDefaults()
        if let username = defaults.objectForKey("ws_username") {
            usernameTextField.text = username as? String
        }
        
        // set the http client delegate for error alerts
        self.httpClient.alertViewController = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func alert(title: String, message: String, handler: ((UIAlertAction) -> (Void))? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: handler))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
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
        
        self.httpClient.login(username, password: password, success: {data -> () in
            print("Got data in main thread")
            if data != nil {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                    self.storeUsername()
                    print(json)
                } catch {
                    self.alert("Error", message: "Login data could not be read")
                }
            }
        })
        
//        WSRequest.login(username, password: password) { (data, response, error) -> () in
//            if error != nil {
//                self.errorAlert(error!)
//                print(error)
//            } else if response != nil {
//                if data != nil {
//                    // login success!
//                    print("got data")
//                    self.storeUsername()
//                    
//                    print(data?.valueForKey("sessid"))
//                } else {
//                    // handle bad response
//                    self.errorAlert(response!)
//                    print(response)
//                }
//            } else {
//                // login unsuccessful
//                print("No response from the server")
//            }
//        }
        
//        WSRequest.logout({ (data, response, error) -> () in
//            if error != nil {
//                self.errorAlert(error!)
//                print(error)
//            } else if response != nil {
//                if data != nil {
//                    // login success!
//                    print("got data")
//                    self.storeUsername()
//                    
//                    print(data?.valueForKey("sessid"))
//                } else {
//                    // handle bad response
//                    self.errorAlert(response!)
//                    print(response)
//                }
//            } else {
//                // login unsuccessful
//                print("No response from the server")
//            }
//        })
        

    }
    
    func storeUsername() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(usernameTextField.text, forKey: "ws_username")
        defaults.synchronize()
    }
    
    func storeSessionCookie() {
        
    }
    
    // MARK: - Alert functions
    
//    func alert(title: String, message: String, handler: ((UIAlertAction) -> (Void))? = nil) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: handler))
//        self.presentViewController(alert, animated: true, completion: nil)
//    }
//    
//    func errorAlert(error: AnyObject) {
//        var title = ""
//        var message = ""
//        if error is NSError {
//            title = "Error"
//            message = error.localizedDescription
//        } else if error is NSHTTPURLResponse {
//            if error.statusCode == 401 {
//                title = "Invalid Login"
//                message = "There was an error with your E-Mail/Password combination. Please try again."
//            } else {
//                title = "Network Error"
//                message = NSHTTPURLResponse.localizedStringForStatusCode(error.statusCode)
//            }
//        } else {
//            title = "Error"
//            message = "Sorry, an unknown error has occured"
//        }
//        self.alert(title, message: message)
//    }
//    
    func presentAlert(alert: UIAlertController) {
        self.presentViewController(alert, animated: true, completion: nil)
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
