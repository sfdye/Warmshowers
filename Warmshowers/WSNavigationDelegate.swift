//
//  WSNavigationDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSNavigationDelegate : WSNavigationProtocol {
    
    static let sharedNavigationDelegate = WSNavigationDelegate()
    
    // app variables
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    func showLoginScreen() {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            let loginViewController = self?.mainStoryboard.instantiateViewControllerWithIdentifier(LoginSBID)
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = loginViewController
        }
    }
    
    func showMainApp() {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = self?.mainStoryboard.instantiateInitialViewController()
        }
    }
    
    func openWarmshowersHomePage() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.warmshowers.org")!)
    }
    
    func openWarmshowersSignUpPage() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.warmshowers.org/user/register")!)
    }
    
    func openWarmshowersFAQPage() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.warmshowers.org/faq")!)
    }
    
    func openFeedbackEmail() {
        UIApplication.sharedApplication().openURL(NSURL(string: "mailto:rajan.fernandez@hotmail.com?subject=Warmshowers%20app")!)
    }
}