//
//  WSCreateFeedbackTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSCreateFeedbackTableViewController : WSAPIResponseDelegate {
    
    func requestDidComplete(request: WSAPIRequest) {
        dispatch_async(dispatch_get_main_queue(), {
            WSProgressHUD.hide(self.navigationController!.view)
            })
    }
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            self?.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
            let alert = UIAlertController(title: "Could not submit feedback", message: "Sorry, an error occured while submitting your feedback. Please check you are connected to the internet and try again later.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(okAction)
            self?.presentViewController(alert, animated: true, completion: nil)
        })
    }
}