//
//  NavigationDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 28/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

protocol NavigationProtocol {
    
    /** Shows the login page instead of the main app */
    func showLoginScreen()
    
    /** Shows the main app with the tab bar */
    func showMainApp()
    
    /** Opens a website in a Safari View Controller. */
    func open(url: URL, fromViewController viewController: UIViewController)
    
    /** Opens mail to compose a feedback email */
    func openFeedbackEmail()
    
    /** Handles an application shortcut. */
    func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem, withCompletionHandler completionHandler: (Bool) -> Void)
    
}
