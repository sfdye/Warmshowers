//
//  WSAlertDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSAlertDelegate : WSAlertProtocol {
    
    static let sharedAlertDelegate = WSAlertDelegate()
    
    func presentAlertFor(delegator: UIViewController, withTitle title: String?, button: String?) {
        presentAlertFor(delegator, withTitle: title, button: button, message: nil, andHandler: nil)
    }
    
    func presentAlertFor(delegator: UIViewController, withTitle title: String?, button: String?, message: String?) {
        presentAlertFor(delegator, withTitle: title, button: button, message: message, andHandler: nil)
    }
    
    func presentAlertFor(delegator: UIViewController, withTitle title: String?, button: String?, message: String?, andHandler handler: ((UIAlertAction) -> Void)?) {
        dispatch_async(dispatch_get_main_queue()) { [weak delegator] in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: button, style: UIAlertActionStyle.Default, handler: handler)
            alertController.addAction(action)
            delegator?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}