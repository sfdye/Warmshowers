//
//  WSAccountTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSAccountTableViewController: WSAPIResponseDelegate {
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        //
        
//        // Set the feedback and update the table view
//        self.feedback = feedback
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 2)], withRowAnimation: UITableViewRowAnimation.Automatic)
//        })

    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        //
    }
    
}