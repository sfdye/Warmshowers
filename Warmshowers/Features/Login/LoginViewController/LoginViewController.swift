//
//  LoginViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import WarmshowersData

let SBID_Login = "Login"

class LoginViewController: UIViewController, Delegator, DataSource {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the default username
        usernameTextField.text = session.username
    }
}
