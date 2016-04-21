//
//  WSCreateWSFeedbackTableViewController+WSAPIResponseHandler.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSCreateWSFeedbackTableViewController : WSAPIResponseHandler {
    
    func didRecieveAPISuccessResponse(data: AnyObject?) {
        // Dismiss the view on successful feedback submission
        WSProgressHUD.hide()
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didRecieveAPIFailureResponse(error: ErrorType?) {
        // Show an error
        WSProgressHUD.hide()
        let alert = UIAlertController(title: "Could not submit feedback", message: "Sorry, an error occured while submitted your feedback. Please check you are connected to the internet and try again later.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}