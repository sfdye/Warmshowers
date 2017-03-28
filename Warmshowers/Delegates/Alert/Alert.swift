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
        var title: String = NSLocalizedString("Error", comment: "General error alert title")
        var message: String = NSLocalizedString("An unknown error ocurred", comment: "General error message")
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
                title = NSLocalizedString("Data Parsing Error", comment: "Data parsing error alert title")
                message = String(format: NSLocalizedString("An error occured while parsing data from the Warmshowers API end point %@. ", comment: "Data parsing error details format"), endPoint)
                if key != nil {
                    message += "The error occured while parsing key: '\(key)'. "
                }
                message += NSLocalizedString("Please report this as a bug.", comment: "Bug reporting request")
            default:
                break
            }
        case is APICommunicatorError:
            switch (error as! APICommunicatorError) {
            case .offline:
                // Case is handled by the reachability banner.
                return
            case .serverError(let statusCode, _):
                title = NSLocalizedString("Server Error", comment: "Server error alert title")
                message = String(format: NSLocalizedString("The server responded with %d.", comment: "Server error message format"), statusCode)
            default:
                title = NSLocalizedString("API Error", comment: "API error alert title")
                message = NSLocalizedString("An error occured while contacting the Warmshowers API. Please report this as a bug.", comment: "API error alert message")
            }
        case is APIAuthorizerError:
            switch (error as! APIAuthorizerError) {
            case .invalidAuthorizationData:
                // Do not show errors for these. Auto login is handled by APICommunicator.
                return
            default:
                title = NSLocalizedString("API Authorization Error", comment: "Authorization error alert title")
            }
        default:
            break
        }
        let button = NSLocalizedString("OK", comment: "OK button title")
        presentAlertFor(delegator, withTitle: title, button: button, message: message)
    }
    
    func showNoInternetBanner() {
        DispatchQueue.main.async { () -> Void in
            let banner = AFMInfoBanner()
            banner.text = NSLocalizedString("No Internet Connection", comment: "Text shown in a banner when there is no internet connection")
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
