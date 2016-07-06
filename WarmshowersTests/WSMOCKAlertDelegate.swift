//
//  WSMOCKAlertDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
@testable import Warmshowers

class WSMOCKAlertDelegate : WSAlertProtocol {
    
    var presentAlertCalled = false
    var title: String?
    var message: String?
    var button: String?
    var handler: ((UIAlertAction) -> Void)?
    var error: ErrorProtocol?
    
    var showNoInternetBannerCalled = false
    var hideAllBannersCalled = false
    
    func presentAlertFor(_ delegator: UIViewController?, withTitle title: String?, button: String?) {
        presentAlertFor(delegator, withTitle: title, button: button, message: nil, andHandler: nil)
    }
    
    func presentAlertFor(_ delegator: UIViewController?, withTitle title: String?, button: String?, message: String?) {
        presentAlertFor(delegator, withTitle: title, button: button, message: message, andHandler: nil)
    }
    
    func presentAlertFor(_ delegator: UIViewController?, withTitle title: String?, button: String?, message: String?, andHandler handler: ((UIAlertAction) -> Void)?) {
        self.title = title
        self.message = message
        self.button = button
        self.handler = handler
        presentAlertCalled = true
    }
    
    func presentAPIError(_ error: ErrorProtocol, forDelegator delegator: UIViewController?) {
        self.error = error
        presentAlertCalled = true
    }
    
    func showNoInternetBanner() {
        showNoInternetBannerCalled = true
    }
    
    func hideAllBanners() {
        hideAllBannersCalled = true
    }
}
