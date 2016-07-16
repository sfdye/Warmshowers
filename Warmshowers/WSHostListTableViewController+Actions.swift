//
//  WSHostListTableViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 11/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSHostListTableViewController {
    
    @IBAction func doneButtonPressed() {
        dispatch_async(dispatch_get_main_queue()) { 
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}