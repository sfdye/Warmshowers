//
//  WSKeywordSearchTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSKeywordSearchTableViewController : WSLazyImageTableViewController {
    
    var debounceTimer: NSTimer?
    
    // Delegates
    var alertDelegate: WSAlertDelegate = WSAlertDelegate.sharedAlertDelegate
    var apiCommunicator: WSAPICommunicator? = WSAPICommunicator.sharedAPICommunicator
    
    override func viewDidLoad() {
        dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: Utility methods
    
    func searchWithKeywordOnTimer(timer: NSTimer) {
        guard let keyword = timer.userInfo as? String else {
            return
        }
        apiCommunicator?.searchByKeyword(keyword, offset: 0, andNotify: self)
        debounceTimer = nil
    }
    
    /** Reloads the table view with an array of results */
    func reloadTableWithHosts(hosts: [WSUserLocation]) {
        self.lazyImageObjects = hosts
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            self?.tableView.reloadData()
            })
    }
}
