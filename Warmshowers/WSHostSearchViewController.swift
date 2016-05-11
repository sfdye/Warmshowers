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
        showMapView()

        // Configure components
        configureSearchController()
        
        // Reachability notifications
        connection.registerForAndStartNotifications(self, selector: #selector(WSHostSearchViewController.reachabilityChanged(_:)))
    }

    override func viewWillAppear(animated: Bool) {
        showReachabilityBannerIfNeeded()
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchBar = searchController.searchBar
        
        // Search controller
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        // Search bar
        searchBar.barTintColor = WSColor.NavbarGrey
        searchBar.placeholder = "Search by name, email or town"
    }


    // MARK: Reachability
    
    func reachabilityChanged(note: NSNotification) {
        showReachabilityBannerIfNeeded()
    }
    
    func showReachabilityBannerIfNeeded() {
        if !connection.isOnline {
            WSInfoBanner.showNoInternetBanner()
        } else {
            WSInfoBanner.hideAll()
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
