//
//  HostMapViewController+WSRequestAlerts.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

extension HostMapViewController: WSRequestAlert {
    
    // MARK: - WSRequestAlert Delegate functions
    
    func requestAlert(title: String, message: String) {
        
        guard alertController == nil else {
            return
        }
        
        alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        if alertController != nil {
            alertController?.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: { (action) -> Void in
                self.alertController = nil
            }))
            self.presentViewController(alertController!, animated: true, completion: nil)
        }
    }
    
}