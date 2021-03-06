//
//  NavigationDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import SafariServices

class Navigation: NavigationDelegate {
    
    static let shared = Navigation()
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func showLoginScreen() {
        DispatchQueue.main.async { [unowned self] in
            let loginViewController = self.loginStoryboard.instantiateInitialViewController()
            self.appDelegate.window?.rootViewController = loginViewController
        }
    }
    
    func showMainApp() {
        DispatchQueue.main.async { [unowned self] in
            let tabViewController = self.mainStoryboard.instantiateInitialViewController()
            self.appDelegate.window?.rootViewController = tabViewController
        }
    }
    
    func open(url: URL, fromViewController viewController: UIViewController) {
        let svc = SFSafariViewController(url: url)
        svc.preferredBarTintColor = .white
        svc.preferredControlTintColor = WarmShowersColor.Blue
        viewController.present(svc, animated: true, completion: nil)
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
        ProgressHUD.hide()
        
        // Dismiss any presented account views.
        let hostSearchVC = (tabVC.selectedViewController as? UINavigationController)?.viewControllers.first as? HostSearchViewController
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
