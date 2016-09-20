//
//  WSCreateFeedbackTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSCreateFeedbackTableViewController : WSAPIResponseDelegate {
    
    func requestDidComplete(_ request: WSAPIRequest) {
        DispatchQueue.main.async(execute: {
            WSProgressHUD.hide(self.navigationController?.view)
            })
    }
    
    func request(_ request: WSAPIRequest, didSuceedWithData data: Any?) {
        DispatchQueue.main.async(execute: { [weak self] in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    func request(_ request: WSAPIRequest, didFailWithError error: Error) {
        DispatchQueue.main.async(execute: { [weak self] () -> Void in
            let alert = UIAlertController(title: "Could not submit feedback", message: "Sorry, an error occured while submitting your feedback. Please check you are connected to the internet and try again later.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self?.present(alert, animated: true, completion: nil)
        })
    }
}
