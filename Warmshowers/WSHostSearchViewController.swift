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
import ReachabilitySwift
import CCHMapClusterController

// TODOs
// address this issue (add gps routes to the map)
// https://ro.warmshowers.org/node/112508
// - make the pin clustering like the website and android app

class WSHostSearchViewController: UIViewController {
    
    @IBOutlet var locationSearchView: UIView!
    @IBOutlet var keywordSearchView: UIView!
    
    var searchController: UISearchController!
    var searchBar: UISearchBar!
    
    // var locationSearchViewController: WSLocationSearchViewController?
    var keywordSearchTableViewController: UISearchResultsUpdating?

    // Delegates
    var alertDelegate: WSAlertDelegate = WSAlertDelegate.sharedAlertDelegate
    var connection: WSReachabilityProtocol = WSReachabilityManager.sharedReachabilityManager
    var session: WSSessionStateProtocol = WSSessionState.sharedSessionState
    
    // MARK: View life cycle
    
    deinit {
        connection.deregisterFromNotifications(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set references to child views
        keywordSearchTableViewController = self.childViewControllers.last as? UISearchResultsUpdating
        assert(keywordSearchTableViewController != nil, "Keyword Search Table View Controller not set while loading the Host Search View Controller. Check that WSKeywordSearchTableViewCOntroller conforms to UISearchResultsUpdating.")
        
        showMapView()
        
        // Reachability notifications
        connection.registerForAndStartNotifications(self, selector: #selector(WSHostSearchViewController.reachabilityChanged(_:)))
        
        // Search controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = keywordSearchTableViewController!
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        // Search bar
        searchBar = searchController.searchBar
        searchBar.placeholder = "Search by name, email or town"
    }

    override func viewWillAppear(animated: Bool) {
        showReachabilityBannerIfNeeded()
    }

    // MARK: Reachability
    
    func reachabilityChanged(note: NSNotification) {
        showReachabilityBannerIfNeeded()
    }
    
    func showReachabilityBannerIfNeeded() {
        if !connection.isOnline {
            alertDelegate.showNoInternetBanner()
        } else {
            alertDelegate.hideAllBanners()
        }
    }
    
    
    // MARK: View switching
    
    /** Shows the host map and hides the search by keyword table view */
    func showMapView() {
        UIView.transitionWithView(keywordSearchView, duration: 0.1, options: .TransitionCrossDissolve, animations: { [weak self] () -> Void in
            self?.keywordSearchView.hidden = true
            }, completion: nil)
    }
    
    /** Shows the search by keyword table view and hides the host map */
    func showTableView() {
        UIView.transitionWithView(keywordSearchView, duration: 0.1, options: .TransitionCrossDissolve, animations: { [weak self] () -> Void in
            self?.keywordSearchView.hidden = false
            }, completion: nil)
    }
}
