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
    var hosts: [WSUserLocation]? = [WSUserLocation]()
    var numberOfHosts: Int { return hosts?.count ?? 0 }
    
    var navigationDelegate: WSHostSearchNavigationDelegate?
    
    // Delegates
    var alert: WSAlertDelegate = WSAlertDelegate.sharedAlertDelegate
    var api: WSAPICommunicatorProtocol = WSAPICommunicator.sharedAPICommunicator
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(placeholderImage != nil, "Placeholder image not found while loading WSKeywordSearchTableViewController.")        
    }
    
    override func viewWillAppear(animated: Bool) {
        assert(navigationDelegate != nil, "The navigation delegate for WSKeywordSearchTableViewController not set. Please ensure the delegate is set before the view appears.")
    }
    
    // MARK: Utility methods
    
    func searchWithKeywordOnTimer(timer: NSTimer) {
        
        guard let keyword = timer.userInfo as? String else {
            return
        }
        
        debounceTimer = nil
        let searchData = WSKeywordSearchData(keyword: keyword)
        api.contactEndPoint(.SearchByKeyword, withPathParameters: nil, andData: searchData, thenNotify: self)
    }
    
    func startImageDownloadForIndexPath(indexPath: NSIndexPath) {
        guard let hosts = hosts where indexPath.row < numberOfHosts else { return }
        let user = hosts[indexPath.row]
        if let url = user.imageURL where user.image == nil {
            api.contactEndPoint(.ImageResource, withPathParameters: url as NSString, andData: nil, thenNotify: self)
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
    
    /** Sets the image for a host in the list with the given image URL. */
    func setImage(image: UIImage, forHostWithImageURL imageURL: String) {
        guard let hosts = hosts else { return }
        for (index, host) in hosts.enumerate() {
            if host.imageURL == imageURL {
                host.image = image ?? placeholderImage
                dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                    self?.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .None)
                    })
            }
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
