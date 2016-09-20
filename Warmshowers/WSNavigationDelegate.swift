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
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func showLoginScreen() {
        DispatchQueue.main.async { [unowned self] in
            let loginViewController = self.mainStoryboard.instantiateViewController(withIdentifier: SBID_Login)
            self.appDelegate.window?.rootViewController = loginViewController
        }
    }
    
    func showMainApp() {
        DispatchQueue.main.async { [unowned self] in
            self.appDelegate.window?.rootViewController = self.mainStoryboard.instantiateInitialViewController()
        }
    }
    
    func openWarmshowersHomePage() {
        let url = URL(string: "https://www.warmshowers.org")!
        UIApplication.shared.open(url, options: [String : Any](), completionHandler: nil)
    }
    
    func openWarmshowersSignUpPage() {
        let url = URL(string: "https://www.warmshowers.org/user/register")!
        UIApplication.shared.open(url, options: [String : Any](), completionHandler: nil)
    }
    
    func openWarmshowersFAQPage() {
        let url = URL(string: "https://www.warmshowers.org/faq")!
        UIApplication.shared.open(url, options: [String : Any](), completionHandler: nil)
    }
    
    func openFeedbackEmail() {
        let url = URL(string: "mailto:rajan.fernandez@hotmail.com?subject=Warmshowers%20app")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [String : Any](), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem, withCompletionHandler completionHandler: (Bool) -> Void) {
        // If the user is not in the main app, do nothing.
        guard let tabVC = appDelegate.window?.rootViewController as? UITabBarController else { return }
        guard let shortcut = ShortcutIdentifier(fullType: shortcutItem.type) else { return }
        
        // If the app is backgrounded while a HUD was showing, then resumed with a shortcut, the HUD is not fully dismissed. So we ensure that all HUDs are dismissed here.
        WSProgressHUD.hide()
        
        // Dismiss any presented account views.
        let hostSearchVC = (tabVC.selectedViewController as? UINavigationController)?.viewControllers.first as? WSHostSearchViewController
        if hostSearchVC != nil {
            if let presentedVC = hostSearchVC!.presentedViewController {
                presentedVC.dismiss(animated: true, completion: {
                    
                })
            }
        }
        
        switch shortcut {
        case .LocationSearch, .KeywordSearch:
            DispatchQueue.main.async {
                tabVC.selectedIndex = 0
                // If the keyword search shortcut was used, activate the search controller.
                if shortcut == .KeywordSearch {
                    hostSearchVC?.searchButtonPressed(nil)
                }
            }
        case .Messages:
            DispatchQueue.main.async {
                tabVC.selectedIndex = 1
            }
        }
        
        completionHandler(true)
    }
    
}
