//
//  LoginViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

let SBID_Login = "Login"

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // Delegates
    var session: SessionStateProtocol = SessionState.sharedSessionState
    var navigation: NavigationProtocol = NavigationDelegate.sharedNavigationDelegate
    var api: APICommunicatorProtocol = APICommunicator.sharedAPICommunicator
    var alert: AlertProtocol = AlertDelegate.sharedAlertDelegate
    

    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the default username
        usernameTextField.text = session.username
    }
}
