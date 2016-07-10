//
//  WSCreateFeedbackTableViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSCreateFeedbackTableViewController {
    
    @IBAction func cancelButtonPressed(sender: AnyObject?) {
        
        self.view.endEditing(true)
        
        if feedback.hasBody {
            // TODO: Delegate this to the alertDelgate
            let alert = UIAlertController(title: nil, message: "Are you sure you want to discard the current feedback?", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            let continueAction = UIAlertAction(title: "Continue", style: .Default) { (continueAction) -> Void in
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(continueAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func sumbitButtonPressed(sender: AnyObject?) {
        
        self.view.endEditing(true)
        
        guard let _ = feedback.recommendedUserName else {
            alert?.presentAlertFor(self, withTitle: "An error occured", button: "OK", message: "Recommended user not set. Please report this as a bug, sorry for the inconvenience.")
            return
        }
        
        guard feedback.hasBody else {
            alert?.presentAlertFor(self, withTitle: "No feedback to submit", button: "OK", message: "Please enter some feedback before submitting.")
            return
        }
        
        // Submit the feedback
        WSProgressHUD.show("Submitting feedback ...")
//        api?.createFeedback(feedback, andNotify: self)
    }
}