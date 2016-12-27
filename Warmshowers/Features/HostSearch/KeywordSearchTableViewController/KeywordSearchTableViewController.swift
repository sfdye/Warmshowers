//
//  KeywordSearchTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import WarmshowersData

class KeywordSearchTableViewController: UITableViewController, Delegator, DataSource {
    
    var debounceTimer: Timer?
    var placeholderImage: UIImage? = UIImage(named: "ThumbnailPlaceholder")
    var hosts: [UserLocation]? = [UserLocation]()
    var numberOfHosts: Int { return hosts?.count ?? 0 }
    
    var navigationDelegate: HostSearchNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(placeholderImage != nil, "Placeholder image not found while loading KeywordSearchTableViewController.")        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        assert(navigationDelegate != nil, "The navigation delegate for KeywordSearchTableViewController not set. Please ensure the delegate is set before the view appears.")
    }
    
    // MARK: Utility methods
    
    func searchWithKeywordOnTimer(_ timer: Timer) {
        
        guard let keyword = timer.userInfo as? String else {
            return
        }
        
        debounceTimer = nil
        let searchData = KeywordSearchData(keyword: keyword)
        api.contact(endPoint: .searchByKeyword, withMethod: .post, andPathParameters: nil, andData: searchData, thenNotify: self)
    }
    
    func startImageDownloadForIndexPath(_ indexPath: IndexPath) {
        guard let hosts = hosts , (indexPath as NSIndexPath).row < numberOfHosts else { return }
        let user = hosts[(indexPath as NSIndexPath).row]
        if let url = user.imageURL , user.image == nil {
            api.contact(endPoint: .imageResource, withMethod: .get, andPathParameters: url as NSString, andData: nil, thenNotify: self)
        }
    }
    
    func loadImagesForObjectsOnScreen() {
        
        guard
            let visiblePaths = tableView.indexPathsForVisibleRows
            , hosts != nil && numberOfHosts > 0
            else {
                return
        }
        
        for indexPath in visiblePaths {
            startImageDownloadForIndexPath(indexPath)
        }
    }
    
    /** Sets the image for a host in the list with the given image URL. */
    func setImage(_ image: UIImage, forHostWithImageURL imageURL: String) {
        guard let hosts = hosts else { return }
        for (index, host) in hosts.enumerated() {
            if host.imageURL == imageURL {
                host.image = image
                DispatchQueue.main.async(execute: { [weak self] () -> Void in
                    self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    })
            }
        }
    }
    
    /** Reloads the table view with an array of results. */
    func reloadTableWithHosts(_ hosts: [UserLocation]?) {
        self.hosts = hosts
        DispatchQueue.main.async(execute: { [weak self] in
            self?.tableView.reloadData()
            })
    }
    
    /** Clears the table view. */
    func clearTable() {
        reloadTableWithHosts([UserLocation]())
    }
    
    /** Clears the table view and shows the spinner/loading table view cell */
    func showSpinner() {
        reloadTableWithHosts(nil)
    }
}
