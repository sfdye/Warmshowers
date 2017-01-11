//
//  CreateFeedbackTableViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension CreateFeedbackTableViewController {
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject?) {
        
        self.view.endEditing(true)
        
        if recommendation.hasBody {
            // TODO: Delegate this to the alertDelgate
            let alert = UIAlertController(title: nil, message: "Are you sure you want to discard the current feedback?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let continueAction = UIAlertAction(title: "Continue", style: .default) { (continueAction) -> Void in
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
            alert.addAction(continueAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func sumbitButtonPressed(_ sender: AnyObject?) {
        
        self.view.endEditing(true)
        
        guard let _ = recommendation.recommendedUserName else {
            alert.presentAlertFor(self, withTitle: "An error occured", button: "OK", message: "Recommended user not set. Please report this as a bug, sorry for the inconvenience.")
            return
        }
        
        guard recommendation.hasBody else {
            alert.presentAlertFor(self, withTitle: "No feedback to submit", button: "OK", message: "Please enter some feedback before submitting.")
            return
        }
        
        // Submit the feedback
        ProgressHUD.show(navigationController?.view, label: "Submitting feedback ...")
        api.contact(endPoint: .createFeedback, withMethod: .post, andPathParameters: nil, andData: recommendation, thenNotify: self, ignoreCache: false)
    }
}
