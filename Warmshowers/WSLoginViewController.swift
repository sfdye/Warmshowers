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

    // Delegates
    var sessionState: WSSessionStateProtocol? = WSSessionState.sharedSessionState
    var navigationDelegate: WSNavigationProtocol? = WSNavigationDelegate.sharedNavigationDelegate
    var apiCommunicator: WSAPICommunicatorProtocol? = WSAPICommunicator.sharedAPICommunicator
    var alertDelegate: WSAlertProtocol? = WSAlertDelegate.sharedAlertDelegate
    

    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the default username
        usernameTextField.text = sessionState?.username
    }
}
