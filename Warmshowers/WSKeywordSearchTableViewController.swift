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
    override var tableView: UITableView! {
        didSet {
            dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight = 74
            tableView.rowHeight = UITableViewAutomaticDimension
            placeholderImageName = "ThumbnailPlaceholder"
        }
    }
    
    // Delegates
    var delegate: WSHostSearchControllerDelegate?
    var apiCommunicator: WSAPICommunicator? = WSAPICommunicator.sharedAPICommunicator
    
    
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
