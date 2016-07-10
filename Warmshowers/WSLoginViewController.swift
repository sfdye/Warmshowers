//
//  WSLoginViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 18/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

let SBID_Login = "Login"

class WSLoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // Delegates
    var session: WSSessionStateProtocol = WSSessionState.sharedSessionState
    var navigation: WSNavigationProtocol = WSNavigationDelegate.sharedNavigationDelegate
    var api: WSAPICommunicatorProtocol = WSAPICommunicator.sharedAPICommunicator
    var alert: WSAlertProtocol = WSAlertDelegate.sharedAlertDelegate
    

    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the default username
        usernameTextField.text = session.username
    }
}
