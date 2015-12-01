//
//  MessageThreadsTableViewController+WSRequestAlerts.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

extension MessageThreadsTableViewController : WSRequestAlert {
    
    // MARK: - WSRequestAlert Delegate functions
    
    func requestAlert(title: String, message: String) {
        
        guard alertController == nil else {
            return
        }
        
        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        if alertController != nil {
            alertController?.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.alertController = nil
            }))
            self.presentViewController(alertController!, animated: true, completion: nil)
        }
    }
    
}