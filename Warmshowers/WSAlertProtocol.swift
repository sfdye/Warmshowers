//
//  WSAlertProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

protocol WSAlertProtocol {
    
    /** Attempts to present an alert on the given view controller */
    func presentAlertFor(delegator: UIViewController, withTitle: String?, button: String?)
    func presentAlertFor(delegator: UIViewController, withTitle: String?, button: String?, message: String?)
    func presentAlertFor(delegator: UIViewController, withTitle: String?, button: String?, message: String?, andHandler handler: ((UIAlertAction) -> Void)?)
    
    /** Attempts to present an api error alert on the given view controller */
    func presentAPIError(error: ErrorType, forDelegator delegator: UIViewController)
}