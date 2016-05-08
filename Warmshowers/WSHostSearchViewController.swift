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
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var infoLabel: UILabel!
    
    var searchController: UISearchController!
    var searchBar: UISearchBar!
    
    // MARK: Constants
    
    let kDefaultRegionLatitudeDelta: CLLocationDegrees = 1
    let kDefaultRegionLongitudeDelta: CLLocationDegrees = 1
    
    // MARK: Properties
    
    let locationManager = CLLocationManager()
    
    // Delegates
    var alertDelegate: WSAlertDelegate? = WSAlertDelegate.sharedAlertDelegate
    var connection: WSReachabilityProtocol = WSReachabilityManager.sharedReachabilityManager
    var session: WSSessionStateProtocol = WSSessionState.sharedSessionState
    var locationSearchController: WSLocationSearchViewControllerProtocol? = WSLocationSearchViewController()
    var keywordSearchController: WSKeywordSearchTableViewControllerProtocol? = WSKeywordSearchTableViewController()
    
    
    // MARK: View life cycle
    
    deinit {
        connection.deregisterFromNotifications(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMapView()
        
        // Ask the users permission to use location services
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.showsUserLocation = true
        centreOnRegion()
        
        infoLabel.text = nil
        locationSearchController?.mapView = mapView
        locationSearchController?.delegate = self
        keywordSearchController?.tableView = tableView
        keywordSearchController?.delegate = self

        // Configure components
        configureSearchController()
        configureToolbar()
        
        // Reachability notifications
        connection.registerForAndStartNotifications(self, selector: #selector(WSHostSearchViewController.reachabilityChanged(_:)))
    }
    
    override func viewWillAppear(animated: Bool) {
        showReachabilityBannerIfNeeded()
    }
    
//    override func viewWillDisappear(animated: Bool) {
//        WSURLSession.cancelAllDataTasksWithCompletionHandler()
//    }
    
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
    
    func configureToolbar() {
        // This fix removes a shadow line from the top of the toolbar.
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .Any, barMetrics: .Default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .Any)
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
    
    
    // MARK: Map centring
    
    func centreOnRegion() {
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: kDefaultRegionLatitudeDelta, longitudeDelta: kDefaultRegionLongitudeDelta))
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    // MARK: View switching
    
    /** Shows the host map and hides the search by keyword table view */
    func showMapView() {
        UIView.transitionWithView(tableView, duration: 0.1, options: .TransitionCrossDissolve, animations: { [weak self] () -> Void in
            self?.tableView.hidden = true
            self?.toolbar.hidden = false
            self?.infoLabel.hidden = false
            }, completion: nil)
    }
    
    /** Shows the search by keyword table view and hides the host map */
    func showTableView() {
        UIView.transitionWithView(tableView, duration: 0.1, options: .TransitionCrossDissolve, animations: { [weak self] () -> Void in
            self?.tableView.hidden = false
            self?.toolbar.hidden = true
            self?.infoLabel.hidden = true
            }, completion: nil)
    }
    
}
