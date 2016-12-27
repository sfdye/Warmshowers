//
//  MOCKApplicationDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 28/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
@testable import Warmshowers

class MOCKNavigation: NavigationDelegate {
    
    var showLoginScreenCalled = false
    var showMainAppCalled = false
    var openURLFromViewControllerCalled = false
    var openFeedbackEmailCalled = false
    var handleShortcutItemCalled = false
    
    func showLoginScreen() {
        showMainAppCalled = true
    }
    
    func showMainApp() {
        showMainAppCalled = true
    }
    
    func open(url: URL, fromViewController viewController: UIViewController) {
        openURLFromViewControllerCalled = true
    }
    
    func openFeedbackEmail() {
        openFeedbackEmailCalled = true
    }
    
    func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem, withCompletionHandler completionHandler: (Bool) -> Void) {
        handleShortcutItemCalled = true
    }
}
