//
//  WSKeywordSearchTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSKeywordSearchTableViewController: UITableViewController {
    
    var debounceTimer: NSTimer?
    var placeholderImage: UIImage? = UIImage(named: "ThumbnailPlaceholder")
    var hosts: [WSUserLocation]?
    var numberOfHosts: Int { return hosts?.count ?? 0 }
    
    // Delegates
    var alertDelegate: WSAlertDelegate = WSAlertDelegate.sharedAlertDelegate
    var apiCommunicator: WSAPICommunicator? = WSAPICommunicator.sharedAPICommunicator
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(placeholderImage != nil, "Placeholder image not found while loading WSKeywordSearchTableViewController.")
    }
    
    // MARK: Utility methods
    
    func searchWithKeywordOnTimer(timer: NSTimer) {
        
        guard let keyword = timer.userInfo as? String else {
            return
        }
        
        debounceTimer = nil
        apiCommunicator?.searchByKeyword(keyword, offset: 0, andNotify: self)
    }
    
    func startImageDownloadForIndexPath(indexPath: NSIndexPath) {
        
        guard let hosts = hosts where indexPath.row < numberOfHosts else {
            return
        }
        
        let user = hosts[indexPath.row]
        if let url = user.imageURL where user.image == nil {
            apiCommunicator?.getImageAtURL(url, andNotify: self)
        }
    }
    
    func loadImagesForObjectsOnScreen() {
        
        guard
            let visiblePaths = tableView.indexPathsForVisibleRows
            where hosts != nil && numberOfHosts > 0
            else {
                return
        }
        
        for indexPath in visiblePaths {
            startImageDownloadForIndexPath(indexPath)
        }
    }
    
    /** Reloads the table view with an array of results. */
    func reloadTableWithHosts(hosts: [WSUserLocation]?) {
        self.hosts = hosts
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            self?.tableView.reloadData()
            })
    }
    
    /** Clears the table view. */
    func clearTable() {
        reloadTableWithHosts([WSUserLocation]())
    }
    
    /** Clears the table view and shows the spinner/loading table view cell */
    func showSpinner() {
        reloadTableWithHosts(nil)
    }
}
