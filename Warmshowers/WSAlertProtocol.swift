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
    func presentAlertFor(_ delegator: UIViewController?, withTitle: String?, button: String?)
    func presentAlertFor(_ delegator: UIViewController?, withTitle: String?, button: String?, message: String?)
    func presentAlertFor(_ delegator: UIViewController?, withTitle: String?, button: String?, message: String?, andHandler handler: ((UIAlertAction) -> Void)?)
    
    /** Attempts to present an api error alert on the given view controller */
    func presentAPIError(_ error: ErrorProtocol, forDelegator delegator: UIViewController?)
    
    /** Shows a 'No Internet Connection' info banner under the nav bar*/
    func showNoInternetBanner()
    func hideAllBanners()
}
