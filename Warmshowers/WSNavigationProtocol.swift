//
//  WSNavigationDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 28/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

protocol WSNavigationProtocol {
    
    /** Shows the login page instead of the main app */
    func showLoginScreen()
    
    /** Shows the main app with the tab bar */
    func showMainApp()
    
    /** Opens the Warmshowers homepage in safari */
    func openWarmshowersHomePage()
    
    /** Opens the Warmshowers sign up page in safari */
    func openWarmshowersSignUpPage()
    
    /** Opens the Warmshowers FAQ page in safari */
    func openWarmshowersFAQPage()
    
    /** Opens mail to compose a feedback email */
    func openFeedbackEmail()
    
    /** Handles an application shortcut. */
    func handleShortcutItem(shortcutItem: UIApplicationShortcutItem, withCompletionHandler completionHandler: (Bool) -> Void)
    
}