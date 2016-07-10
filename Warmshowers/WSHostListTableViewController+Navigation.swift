//
//  WSHostListTableViewController+Navigation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 11/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostListTableViewController {
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return sender is WSUser
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard sender is WSUser else { return }
        let accountTVC = segue.destinationViewController as! WSAccountTableViewController
        accountTVC.user = sender as? WSUser
    }
    
}