//
//  HostsViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CCHMapClusterController
import WarmshowersData

let SID_SearchViewToUserAccount = "SearchViewToUserAccount"
let SBID_HostSearch = "HostSearchView"
let SBID_LocationSearchView = "LocationSearchView"
let SBID_KeywordSearchView = "KeywordSearchView"

class HostSearchViewController: UIViewController, Delegator, DataSource {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var viewSwitcherButton: UIBarButtonItem!
    
    var searchController: UISearchController!
    var searchBar: UISearchBar!
    
    var locationSearchViewController: LocationSearchViewController?
    var keywordSearchTableViewController: KeywordSearchTableViewController?
    
    // MARK: View life cycle
    
    deinit {
        api.connection.deregisterFromNotifications(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set references to child views
        locationSearchViewController = childViewControllers.first as? LocationSearchViewController
        assert(locationSearchViewController != nil, "Location Search Table View Controller not set while loading the Host Search View Controller.")
        locationSearchViewController?.navigationDelegate = self
        keywordSearchTableViewController = storyboard?.instantiateViewController(withIdentifier: SBID_KeywordSearchView) as? KeywordSearchTableViewController
        assert(keywordSearchTableViewController != nil, "Keyword Search Table View Controller not set while loading the Host Search View Controller.")
        assert(keywordSearchTableViewController is UISearchResultsUpdating, "KeywordSearchTableViewCOntroller must conform to UISearchResultsUpdating.")
        keywordSearchTableViewController?.navigationDelegate = self
        
        // Search controller
        searchController = UISearchController(searchResultsController: keywordSearchTableViewController!)
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = (keywordSearchTableViewController as! UISearchResultsUpdating)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        // Search bar
        searchBar = searchController.searchBar
        searchBar.placeholder = NSLocalizedString("Search by name, email or town", tableName: "HostSearch", comment: "Host search placeholder")
        searchBar.barTintColor = UIColor.white
        
        // Reachability notifications
        api.connection.registerForAndStartNotifications(self, selector: #selector(HostSearchViewController.reachabilityChanged(_:)))
    }

    override func viewWillAppear(_ animated: Bool) {
        showReachabilityBannerIfNeeded()
    }
    

    // MARK: Reachability
    
    func reachabilityChanged(_ note: Notification) {
        showReachabilityBannerIfNeeded()
    }
    
    func showReachabilityBannerIfNeeded() {
        if !api.connection.isOnline {
            alert.showNoInternetBanner()
        } else {
            alert.hideAllBanners()
        }
    }
    
}
