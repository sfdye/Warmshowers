//
//  WSComposeMessageViewController+Navigation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSComposeMessageViewController {
    
    @IBAction func cancelButtonPressed(sender: AnyObject?) {
        
        // Show a warning message if the message body has some content
        guard body == nil || body ?? "" == "" else {
            let alert = UIAlertController(title: nil, message: "Are you sure you want to discard the current message?", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            let continueAction = UIAlertAction(title: "Continue", style: .Default) { (continueAction) -> Void in
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(continueAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}