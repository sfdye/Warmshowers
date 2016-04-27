//
//  WSLoginViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import MBProgressHUD

class WSLoginViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // API communicator
    var apiCommunicator: WSAPICommunicatorProtocol? = WSAPICommunicator.sharedAPICommunicator


    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the default username
        usernameTextField.text = WSSessionData.username
    }
    
    
    // MARK: Utility functions
    
    /**
     Shows an alert with a 'Dismiss' button.
     */
    func alert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(action)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
