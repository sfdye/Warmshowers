//
//  WSMOCKApplicationDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 28/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
@testable import Warmshowers

class WSMOCKNavigationDelegate : WSNavigationProtocol {
    
    var showLoginScreenCalled = false
    var showMainAppCalled = false
    var openWarmshowersHomePageCalled = false
    var openWarmshowersSignUpPageCalled = false
    var openWarmshowersFAQPageCalled = false
    var openFeedbackEmailCalled = false
    
    func showLoginScreen() {
        showMainAppCalled = true
    }
    
    func showMainApp() {
        showMainAppCalled = true
    }
    
    func openWarmshowersHomePage() {
        openWarmshowersHomePageCalled = true
    }
    
    func openWarmshowersSignUpPage() {
        openWarmshowersSignUpPageCalled = true
    }
    
    func openWarmshowersFAQPage() {
        openWarmshowersFAQPageCalled = true
    }
    
    func openFeedbackEmail() {
        openFeedbackEmailCalled = true
    }
}