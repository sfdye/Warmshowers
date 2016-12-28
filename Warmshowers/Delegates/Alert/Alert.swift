//
//  AlertDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import AFMInfoBanner
import WarmshowersData

class Alert: AlertDelegate {
    
    static let shared = Alert()
    
    func presentAlertFor(_ delegator: UIViewController?, withTitle title: String?, button: String?) {
        presentAlertFor(delegator, withTitle: title, button: button, message: nil, andHandler: nil)
    }
    
    func presentAlertFor(_ delegator: UIViewController?, withTitle title: String?, button: String?, message: String?) {
        presentAlertFor(delegator, withTitle: title, button: button, message: message, andHandler: nil)
    }
    
    func presentAlertFor(_ delegator: UIViewController?, withTitle title: String?, button: String?, message: String?, andHandler handler: ((UIAlertAction) -> Void)?) {
        DispatchQueue.main.async { [weak delegator] in
            guard delegator?.presentedViewController == nil else { return }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: button, style: UIAlertActionStyle.default, handler: handler)
            alertController.addAction(action)
            delegator?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func presentAPIError(_ error: Error, forDelegator delegator: UIViewController?) {
        var title: String = "Error"
        var message: String = "An unknown error ocurred."
        switch error {
        case is APIEndPointError:
            switch (error as! APIEndPointError) {
            case .invalidPathParameters:
                assertionFailure("Invalid parameters used for request.")
                break
            case .invalidOutboundData:
                assertionFailure("Invalid outbound data for request.")
                break
            case .parsingError(let endPoint, let key):
                title = "Data Parsing Error"
                message = "An error occured while parsing data from the Warmshowers API end point \(endPoint). "
                if key != nil {
                    message += "The error occured while parsing key: '\(key)'. "
                }
                message += "Please report this as a bug."
            default:
                break
            }
        case is APICommunicatorError:
            switch (error as! APICommunicatorError) {
            case .offline:
                // Case is handled by the reachability banner.
                return
            case .serverError(let statusCode):
                title = "Server Error"
                message = "The server responded with \(statusCode)."
            default:
                title = "API Error"
                message = "An error occured while contacting the Warmshowers API. Please report this as a bug."
            }
        case is APIRequestAuthorizerError:
            switch (error as! APIRequestAuthorizerError) {
            case .invalidAuthorizationData:
                // Do not show errors for these. Auto login is handled by APICommunicator.
                return
            default:
                title = "API Authorization Error"
            }
        default:
            break
        }
        presentAlertFor(delegator, withTitle: title, button: "OK", message: message)
    }
    
    func showNoInternetBanner() {
        DispatchQueue.main.async { () -> Void in
            let banner = AFMInfoBanner()
            banner.text = "No Internet Connection"
            banner.style = .error
            banner.show(true)
        }
    }
    
    func hideAllBanners() {
        DispatchQueue.main.async { () -> Void in
            AFMInfoBanner.hideAll()
        }
    }
}
