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
import kingpin

// TODOs
// address this issue (add gps routes to the map)
// https://ro.warmshowers.org/node/112508
// - make the pin clustering like the website and android app
// add loading indicator to map view

let MapToUserAccountSegueID = "MapToUserAccount"
let ResultsToUserAccountSegueID = "SearchResultsToUserAccount"
let ToHostListSegueID = "ToHostList"
let SpinnerCellID = "Spinner"
let PlaceholderCellID = "Placeholder"

class HostSearchViewController: UIViewController {
    
    // MARK: Properties
    
    let locationManager = CLLocationManager()
    let queue = NSOperationQueue()
    var debounceTimer: NSTimer?
    
    // Main view components / controllers
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var tableView: UITableView!
    var tableViewController = WSLazyImageTableViewController()

    // Map source variables
    var mapSource = WSMapSource.AppleMaps
    var mapOverlay: MKTileOverlay? = nil
    var overlay: MKTileOverlay? = nil
    
    // Host data variables
    var hostsOnMap = [WSUserLocation]()
    var mapUpdater: WSHostsOnMapUpdater?
    var hostsInTable: [WSUserLocation] {
        get {
            return tableViewController.lazyImageObjects as! [WSUserLocation]
        }
        set(newValue) {
            tableViewController.lazyImageObjects = newValue
        }
    }
    
    // Navigation bar items
    var searchButton: UIBarButtonItem!
    var accountButton: UIBarButtonItem!
    
    // Pin clustering controller
    private var clusteringController : KPClusteringController!
    
    // Search controller
    var searchController: UISearchController!
    var searchBar: UISearchBar!
    
    // Toolbar
    @IBOutlet var toolbar: UIToolbar!
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View title
        navigationItem.title = "Host Search"
        
        // Mapview
        mapView.delegate = self
        showMapView()
        
        // Table view
        tableViewController.tableView = tableView
        tableViewController.dataSource = self
        tableViewController.placeholderImageName = "ThumbnailPlaceholder"
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 74
        
        // Search controller and bar
        searchController = UISearchController(searchResultsController: nil)
        searchBar = searchController.searchBar
        
        // Ask the users permission to use location services
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.showsUserLocation = true
        
        // Configure components
        configureNavigationItem()
        configureClusteringController()
        configureSearchController()
        configureQueue()
        
        // Centre the map on the user's location
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            mapView.setRegion(region, animated: true)
            updateHostsOnMap()
        }
        
        // Configure the toolbar
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .Any, barMetrics: .Default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .Any)
        toolbar.tintColor = WSColor.Blue
    }
    
        
    override func viewWillDisappear(animated: Bool) {
        queue.cancelAllOperations()
    }
    
    func configureNavigationItem() {
        
        // Left button
        accountButton = UIBarButtonItem(image: UIImage.init(named: "UserIcon"), style: .Plain, target: self, action: Selector("accountButtonPressed"))
        navigationItem.setLeftBarButtonItem(accountButton, animated: false)
        
        // Right button
        searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: Selector("searchButtonPressed"))
        navigationItem.setRightBarButtonItem(searchButton, animated: false)
    }
    
    func configureSearchController() {
        
        // Search controller
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        // Search bar
        searchBar.barTintColor = WSColor.NavbarGrey
        searchBar.tintColor = WSColor.Blue
        searchBar.placeholder = "Search by name, email or town"
    }
    
    func configureClusteringController() {
        let algorithm : KPGridClusteringAlgorithm = KPGridClusteringAlgorithm()
        algorithm.annotationSize = CGSizeMake(25, 50)
        algorithm.clusteringStrategy = KPGridClusteringAlgorithmStrategy.TwoPhase;
        clusteringController = KPClusteringController(mapView: self.mapView, clusteringAlgorithm: algorithm)
        clusteringController.delegate = self
//        clusteringController.setAnnotations(hostsOnMap)
    }
    
    func configureQueue() {
        queue.maxConcurrentOperationCount = 1
    }

    
    // MARK: Map update methods
    
    // Updates the hosts shown on the map
    //
    func updateHostsOnMap() {
        if mapUpdater == nil {
            mapUpdater = WSHostsOnMapUpdater(hostsOnMap: hostsOnMap, mapView: mapView)
            mapUpdater!.success = {
                // update the cluster controller on the main thread
                if let updater = self.mapUpdater {
                    self.hostsOnMap = updater.hostsOnMap
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.updateClusteringController()
                })
                self.mapUpdater = nil
            }
            mapUpdater!.failure = { (error) -> Void in
                self.mapUpdater = nil
            }
            
            mapUpdater?.tokenGetter.start()
        } else {
            mapUpdater!.cancel()
        }
    }
    
    // Updates the pin clustering controller
    func updateClusteringController() {
        if hostsOnMap.count != 0 {
            clusteringController.setAnnotations(hostsOnMap)
            clusteringController.refresh(true)
        }
    }
    
    @IBAction func centreOnLocation() {
        if let coordinate = locationManager.location?.coordinate {
            mapView.setCenterCoordinate(coordinate, animated: true)
        }
    }

    
    // MARK: Search by keyword methods
    
    // Updates the hosts to be shown in the table view
    //
    func updateSearchResultsWithKeyword() {
        
        guard let keyword = searchController.searchBar.text else {
            return
        }

        // Clear the operation queue
        queue.cancelAllOperations()
        
        // Clear the debounce timer
        debounceTimer = nil
        
        // Update the map annotation data source
        let operation = WSGetHostsForKeywordOperation(keyword: keyword)
        operation.success = { (hosts) -> Void in
            
            self.hostsInTable = hosts

            // update the results table on the main thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        operation.failure = {
            // TODO failure action here
        }
        
        queue.addOperation(operation)
    }
    
    
    // MARK: - Map source methods
    
    // changes the map source
    func switchToMapSource(source: WSMapSource) {
        self.mapSource = source
        setMapOverlay()
    }
    
    // Returns an overlay for the current map source
    func selectMapOverlay() -> MKTileOverlay? {
        
        switch mapSource {
        case .OpenCycleMaps:
            return MKTileOverlay.init(URLTemplate: MapTileServerURLTemplate.OpenCycleMaps())
        case .OpenStreetMaps:
            return MKTileOverlay.init(URLTemplate: MapTileServerURLTemplate.OpenStreetMaps())
        default:
            return nil
        }
        
    }
    
    // Sets the overlay variable to the current map source and update the mapView overlays
    func setMapOverlay() {
        
        // remove the existing overlay object from the mapView
        if mapOverlay != nil {
            mapView.removeOverlay(mapOverlay!)
        }
        
        // set a new map overlay
        if let overlay = selectMapOverlay() {
            overlay.canReplaceMapContent = true;
            mapOverlay = overlay
        } else {
            mapOverlay = nil
        }
        
        // add the new map
        if mapOverlay != nil {
            mapView.addOverlay(mapOverlay!, level: MKOverlayLevel.AboveLabels)
        }
        
    }
    
    // MARK: Navigation methods
    
    func searchButtonPressed() {
        hostsInTable = [WSUserLocation]()
        tableView.reloadData()
        presentViewController(searchController, animated: true, completion: nil)
        searchController.active = true
        didPresentSearchController(searchController)
    }
    
    func accountButtonPressed() {
        performSegueWithIdentifier(MapToUserAccountSegueID, sender: nil)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        switch identifier {
        case MapToUserAccountSegueID:
            
            if let kpAnnotation = sender as? KPAnnotation {
                if let _ = kpAnnotation.annotations.first as? WSUserLocation {
                    return true
                }
            }
            return false
            
        case ResultsToUserAccountSegueID:
            
            if let cell = sender as? HostListTableViewCell {
                if let _ = cell.uid {
                    return true
                }
            }
            return false
            
        case ToHostListSegueID:
            
            if let kpAnnotation = sender as? KPAnnotation {
                if let _ = Array(kpAnnotation.annotations) as? [WSUserLocation] {
                    return true
                }
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
            let accountTVC = navVC.viewControllers.first as! AccountTableViewController
            
            if let kpAnnotation = sender as? KPAnnotation {
                let userLocation = kpAnnotation.annotations.first as? WSUserLocation
                accountTVC.uid = userLocation?.uid
            } else {
                accountTVC.uid = WSLoginData.uid
            }
            
        case ResultsToUserAccountSegueID:
            
            let navVC = segue.destinationViewController as! UINavigationController
            let accountTVC = navVC.viewControllers.first as! AccountTableViewController
            
            if let cell = sender as? HostListTableViewCell {
                accountTVC.uid = cell.uid
            }
            
        case ToHostListSegueID:
            
            let kpAnnotation = sender as! KPAnnotation
            let users = Array(kpAnnotation.annotations) as! [WSUserLocation]
            let navVC = segue.destinationViewController as! UINavigationController
            let hostListTVC = navVC.viewControllers.first as! HostListTableViewController
            hostListTVC.lazyImageObjects = users
            hostListTVC.placeholderImageName = "ThumbnailPlaceholder"
        default:
            return
        }
    }

    
    // MARK: Utilities

    // Checks if a user is already in the map data source
    func userOnMap(uid: Int) -> Bool {
        
        for host in hostsOnMap {
            if host.uid == uid {
                return true
            }
        }
        return false
    }
    
    // Changes between the mapView and tableView
    //
    func showMapView() {
        UIView.transitionWithView(tableView, duration: 0.1, options: .TransitionCrossDissolve, animations: { () -> Void in
            self.tableView.hidden = true
            }, completion: nil)
    }
    
    func showTableView() {
        UIView.transitionWithView(tableView, duration: 0.1, options: .TransitionCrossDissolve, animations: { () -> Void in
            self.tableView.hidden = false
            }, completion: nil)
    }

}
