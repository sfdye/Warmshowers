//
//  CreateFeedbackTableViewController+APIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import WarmshowersData

extension CreateFeedbackTableViewController : APIResponseDelegate {
    
    func requestDidComplete(_ request: APIRequest) {
        DispatchQueue.main.async(execute: {
            ProgressHUD.hide(self.navigationController?.view)
            })
    }
    
    func request(_ request: APIRequest, didSucceedWithData data: Any?) {
        DispatchQueue.main.async(execute: { [weak self] in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    func request(_ request: APIRequest, didFailWithError error: Error) {
        DispatchQueue.main.async(execute: { [weak self] () -> Void in
            let title = NSLocalizedString("Could not submit feedback", comment: "Alert title shown there was an API issue submitting feedback")
            let button = NSLocalizedString("OK", comment: "OK button title")
            let message = NSLocalizedString("Sorry, an error occured while submitting your feedback. Please check you are connected to the internet and try again later.", comment: "Alert message shown there was an API issue submitting feedback")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: button, style: .cancel, handler: nil)
            alert.addAction(okAction)
            self?.present(alert, animated: true, completion: nil)
        })
    }
}
