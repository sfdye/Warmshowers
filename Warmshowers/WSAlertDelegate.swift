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
    
    func presentAPIError(error: ErrorType, forDelegator delegator: UIViewController) {
        var title: String = "Error"
        var message: String = "An unknown error ocurred."
        switch error {
        case is WSAPIEndPointError:
            switch (error as! WSAPIEndPointError) {
            case .ParsingError(let endPoint, let key):
                title = "Data Parsing Error"
                message = "An error occured while parsing data from the Warmshowers API end point \(endPoint). "
                if key != nil {
                    message += "The error occured while parsing key: '\(key)'. "
                }
                message += "Please report this as a bug."
            }
        case is WSAPICommunicatorError:
            switch (error as! WSAPICommunicatorError) {
            case .NoSessionCookie, .NoToken:
                return
            case .Offline:
                // Case is handled by the reachability banner.
                return
            case .ServerError(let statusCode):
                title = "Server Error"
                message = "The server responded with \(statusCode)."
            default:
                title = "API Error"
                message = "An error occured while contacting the Warmshowers API. Please report this as a bug."
            }
        default:
            break
        }
        presentAlertFor(delegator, withTitle: title, button: "OK", message: message)
    }
}