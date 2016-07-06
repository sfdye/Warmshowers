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
        DispatchQueue.main.async { [weak self] in
            let loginViewController = self?.mainStoryboard.instantiateViewController(withIdentifier: LoginSBID)
            let appDelegate = UIApplication.shared().delegate as! AppDelegate
            appDelegate.window?.rootViewController = loginViewController
        }
    }
    
    func showMainApp() {
        DispatchQueue.main.async { [weak self] in
            let appDelegate = UIApplication.shared().delegate as! AppDelegate
            appDelegate.window?.rootViewController = self?.mainStoryboard.instantiateInitialViewController()
        }
    }
    
    func openWarmshowersHomePage() {
        UIApplication.shared().openURL(URL(string: "https://www.warmshowers.org")!)
    }
    
    func openWarmshowersSignUpPage() {
        UIApplication.shared().openURL(URL(string: "https://www.warmshowers.org/user/register")!)
    }
    
    func openWarmshowersFAQPage() {
        UIApplication.shared().openURL(URL(string: "https://www.warmshowers.org/faq")!)
    }
    
    func openFeedbackEmail() {
        UIApplication.shared().openURL(URL(string: "mailto:rajan.fernandez@hotmail.com?subject=Warmshowers%20app")!)
    }
}
