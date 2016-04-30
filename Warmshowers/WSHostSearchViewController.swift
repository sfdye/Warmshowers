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
    
    // MARK: Constants
    
    let kDefaultRegionLatitudeDelta: CLLocationDegrees = 1
    let kDefaultRegionLongitudeDelta: CLLocationDegrees = 1
    
    // MARK: Properties
    
    var mapController: WSMapController!
    var tableViewController = WSLazyImageTableViewController()
    var searchController: UISearchController!
    var searchBar: UISearchBar!
    
    let locationManager = CLLocationManager()
    var debounceTimer: NSTimer?
    
    var mapOverlay: MKTileOverlay?
    var mapSource: WSMapSource = WSMapSource.AppleMaps
    
    // Delegates
    
    var apiCommunicator: WSAPICommunicator? = WSAPICommunicator.sharedAPICommunicator
    var alertDelegate: WSAlertDelegate? = WSAlertDelegate.sharedAlertDelegate
    
    
    // MARK: View life cycle
    
    deinit {
        WSReachabilityManager.deregisterFromNotifications(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMapView()
        
        // Ask the users permission to use location services
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.showsUserLocation = true
        mapView.delegate = self
        centreOnRegion()
        
        infoLabel.text = nil
        
        // Configure components
        configureMapController()
        configureTableViewController()
        configureSearchController()
        configureToolbar()
        
        // Reachability notifications
        WSReachabilityManager.registerForAndStartNotifications(self, selector: #selector(WSHostSearchViewController.reachabilityChanged(_:)))
    }
    
    override func viewWillAppear(animated: Bool) {
        showReachabilityBannerIfNeeded()
    }
    
//    override func viewWillDisappear(animated: Bool) {
//        WSURLSession.cancelAllDataTasksWithCompletionHandler()
//    }
    
    func configureMapController() {
        mapController = WSMapController(withMapView: mapView)
        mapController.delegate = self
        mapController.updateAnnotationsInView()
    }
    
    func configureTableViewController() {
        tableViewController.tableView = tableView
        tableViewController.dataSource = self
        tableViewController.placeholderImageName = "ThumbnailPlaceholder"
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 74
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
        if WSReachabilityManager.sharedInstance?.isReachable() == false {
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
            self?.tableViewController.lazyImageObjects = [WSUserLocation]()
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
    
    
    // MARK: Navigation methods
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        switch identifier {
            
        case MapToUserAccountSegueID:
            
            return sender as? WSUserLocation != nil
            
        case ResultsToUserAccountSegueID:
            
            if let cell = sender as? HostListTableViewCell {
                return cell.uid != nil
            }
            return false
            
        case ToHostListSegueID:
            
            if let clusterAnnotation = sender as? CCHMapClusterAnnotation {
                return Array(clusterAnnotation.annotations) as? [WSUserLocation] != nil
            }
            return false
            
        default:
            return true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier! {
            
        case MapToUserAccountSegueID:
            
            let navVC = segue.destinationViewController as! UINavigationController
            let accountTVC = navVC.viewControllers.first as! WSAccountTableViewController
            
            if let user = sender as? WSUserLocation {
                accountTVC.uid = user.uid
            } else {
                accountTVC.uid = WSSessionData.uid
            }
            
        case ResultsToUserAccountSegueID:
            
            let navVC = segue.destinationViewController as! UINavigationController
            let accountTVC = navVC.viewControllers.first as! WSAccountTableViewController
            
            if let cell = sender as? HostListTableViewCell {
                accountTVC.uid = cell.uid
            }
            
        case ToHostListSegueID:
            
            let navVC = segue.destinationViewController as! UINavigationController
            let hostListTVC = navVC.viewControllers.first as! WSHostListTableViewController
            
            if let clusterAnnotation = sender as? CCHMapClusterAnnotation {
                if let users = Array(clusterAnnotation.annotations) as? [WSUserLocation] {
                    hostListTVC.lazyImageObjects = users
                    hostListTVC.placeholderImageName = "ThumbnailPlaceholder"
                }
            }
            
        default:
            return
        }
    }
    
    // MARK: Updating hosts
    
    // Updates the hosts to be shown in the table view
    //
    func updateSearchResultsWithKeyword() {
        
        guard let keyword = searchController.searchBar.text else {
            return
        }
        
        // Clear the debounce timer
        debounceTimer?.invalidate()
        debounceTimer = nil
        
        apiCommunicator?.searchByKeyword(keyword, offset: 0, andNotify: self)
    }
    
    func reloadTableWithHosts(hosts: [WSUserLocation]) {
        tableViewController.lazyImageObjects = hosts
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            self?.tableView.reloadData()
            })
    }
}
