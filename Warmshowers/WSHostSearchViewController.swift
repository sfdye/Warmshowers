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

let SID_SearchViewToUserAccount = "SearchViewToUserAccount"
let SBID_HostSearch = "HostSearchView"
let SBID_LocationSearchView = "LocationSearchView"
let SBID_KeywordSearchView = "KeywordSearchView"

class WSHostSearchViewController: UIViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var viewSwitcherButton: UIBarButtonItem!
    
    var searchController: UISearchController!
    var searchBar: UISearchBar!
    
    var locationSearchViewController: WSLocationSearchViewController?
    var keywordSearchTableViewController: WSKeywordSearchTableViewController?

    // Delegates
    var alert: WSAlertProtocol = WSAlertDelegate.sharedAlertDelegate
    var api: WSAPICommunicatorProtocol = WSAPICommunicator.sharedAPICommunicator
    var connection: WSReachabilityProtocol = WSReachabilityManager.sharedReachabilityManager
    var session: WSSessionStateProtocol = WSSessionState.sharedSessionState
    
    // MARK: View life cycle
    
    deinit {
        connection.deregisterFromNotifications(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set references to child views
        locationSearchViewController = childViewControllers.first as? WSLocationSearchViewController
        assert(locationSearchViewController != nil, "Location Search Table View Controller not set while loading the Host Search View Controller.")
        locationSearchViewController?.navigationDelegate = self
        keywordSearchTableViewController = storyboard?.instantiateViewController(withIdentifier: SBID_KeywordSearchView) as? WSKeywordSearchTableViewController
        assert(keywordSearchTableViewController != nil, "Keyword Search Table View Controller not set while loading the Host Search View Controller.")
        assert(keywordSearchTableViewController is UISearchResultsUpdating, "WSKeywordSearchTableViewCOntroller must conform to UISearchResultsUpdating.")
        keywordSearchTableViewController?.navigationDelegate = self
        
        // Search controller
        searchController = UISearchController(searchResultsController: keywordSearchTableViewController!)
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = (keywordSearchTableViewController as! UISearchResultsUpdating)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        // Search bar
        searchBar = searchController.searchBar
        searchBar.placeholder = "Search by name, email or town"
        searchBar.barTintColor = UIColor.white
        
        // Reachability notifications
        connection.registerForAndStartNotifications(self, selector: #selector(WSHostSearchViewController.reachabilityChanged(_:)))
    }

    override func viewWillAppear(_ animated: Bool) {
        showReachabilityBannerIfNeeded()
    }
    

    // MARK: Reachability
    
    func reachabilityChanged(_ note: Notification) {
        showReachabilityBannerIfNeeded()
    }
    
    func showReachabilityBannerIfNeeded() {
        if !connection.isOnline {
            alert.showNoInternetBanner()
        } else {
            alert.hideAllBanners()
        }
    }
    
}
