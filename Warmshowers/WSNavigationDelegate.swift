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
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    var appDelegate: AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func showLoginScreen() {
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            let loginViewController = self.mainStoryboard.instantiateViewControllerWithIdentifier(SBID_Login)
            self.appDelegate.window?.rootViewController = loginViewController
        }
    }
    
    func showMainApp() {
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            self.appDelegate.window?.rootViewController = self.mainStoryboard.instantiateInitialViewController()
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
    
    func handleShortcutItem(shortcutItem: UIApplicationShortcutItem, withCompletionHandler completionHandler: (Bool) -> Void) {
        // If the user is not in the main app, do nothing.
        guard let tabVC = appDelegate.window?.rootViewController as? UITabBarController else { return }
        guard let shortcut = ShortcutIdentifier(fullType: shortcutItem.type) else { return }
        
        // If the app is backgrounded while a HUD was showing, then resumed with a shortcut, the HUD is not fully dismissed. So we ensure that all HUDs are dismissed here.
        WSProgressHUD.hide()
        
        // Dismiss any presented account views.
        let hostSearchVC = (tabVC.selectedViewController as? UINavigationController)?.viewControllers.first as? WSHostSearchViewController
        if hostSearchVC != nil {
            if let presentedVC = hostSearchVC!.presentedViewController {
                presentedVC.dismissViewControllerAnimated(true, completion: {
                    
                })
            }
        }
        
        switch shortcut {
        case .LocationSearch, .KeywordSearch:
            dispatch_async(dispatch_get_main_queue()) {
                tabVC.selectedIndex = 0
                // If the keyword search shortcut was used, activate the search controller.
                if shortcut == .KeywordSearch {
                    hostSearchVC?.searchButtonPressed(nil)
                }
            }
        case .Messages:
            dispatch_async(dispatch_get_main_queue()) {
                tabVC.selectedIndex = 1
            }
        }
        
        completionHandler(true)
    }
    
}