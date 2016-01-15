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


enum MapSource {
    case AppleMaps
    case OpenCycleMaps
    case OpenStreetMaps
}

let TO_USER_ACCOUNT_SEGUE_ID = "ToUserAccount"
let TO_HOST_LIST_SEGUE_ID = "ToHostList"

class HostSearchViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var tableView: UITableView!
    
    var alertController: UIAlertController?
    let locationManager = CLLocationManager()
    
    let defaults = (UIApplication.sharedApplication().delegate as! AppDelegate).defaults
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // Map source variables
    var mapSource = MapSource.AppleMaps
    var mapOverlay: MKTileOverlay? = nil
    var overlay: MKTileOverlay? = nil
    
    // Host data variables
    var hostsOnMap = [WSUserLocation]()
    var hostsInTable = [WSUserLocation]()
    
    // Navigation bar items
    var searchButton: UIBarButtonItem!
    var accountButton: UIBarButtonItem!
    
    // Pin clustering controller
    private var clusteringController : KPClusteringController!
    
    // Search controller
    var searchController: UISearchController!
    
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Mapview
        mapView.delegate = self
        showMapView()
        
        // Table view
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        // Configure components
        configureNavigationItem()
        configureClusteringController()
        configureSearchController()
        
        // Centre the map on the user's location
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Ask the users permission to use location services
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.showsUserLocation = true
    }
    
    func configureNavigationItem() {
        
        // Navigation buttons
        searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: Selector("searchButtonPressed"))
        accountButton = UIBarButtonItem(image: UIImage.init(named: "UserIcon"), style: .Plain, target: self, action: Selector("accountButtonPressed"))
        navigationItem.setLeftBarButtonItem(accountButton, animated: false)
        navigationItem.setRightBarButtonItem(searchButton, animated: false)
        
    }
    
    func configureSearchController() {
        
        // Set up the search controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = WSColor.NavbarGrey
    }
    
    func configureClusteringController() {
        let algorithm : KPGridClusteringAlgorithm = KPGridClusteringAlgorithm()
        algorithm.annotationSize = CGSizeMake(25, 50)
        algorithm.clusteringStrategy = KPGridClusteringAlgorithmStrategy.TwoPhase;
        clusteringController = KPClusteringController(mapView: self.mapView, clusteringAlgorithm: algorithm)
        clusteringController.delegate = self
        clusteringController.setAnnotations(hostsOnMap)
    }

    
    // MARK: Map update methods
    
    // Updates the hosts shown on the map
    //
    func updateHostsOnMap() {
        
        WSRequest.getHostDataForMapView(mapView) { (data) -> Void in
            
            // Update the mapView data source
            if data != nil {
                let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                dispatch_async(queue, { () -> Void in
                    self.updateMapDataSource(data!)
                })
            }
        }
    }
    
    // Updates the hosts to be shown in the table view
    //
    func updateSearchResultsWithKeyword(keyword: String) {
        
        WSRequest.getHostDataForKeyword(keyword, offset: 0) { (data) -> Void in
            
            // Update the tableView data source
            if data != nil {
                let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                dispatch_async(queue, { () -> Void in
                    self.updateTableViewDataSource(data!)
                })
            }
        }
    }
    
    // Adds hosts to the map with data from the web
    //
    func updateMapDataSource(data: NSData) {
        
        // parse the json
        if let json = WSRequest.jsonDataToDictionary(data) {
            if let accounts = json["accounts"] as? NSArray {
                for account in accounts {
                    if let user = WSUserLocation(json: account) {
                        if !self.userOnMap(user.uid) {
                            self.hostsOnMap.append(user)
                        }
                    }
                }
            }
        }
        
        // update the cluster controller on the main thread (otherwise it complains)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.updateClusteringController()
        })
    }
    
    // Adds hosts to search results with data from the web
    //
    func updateTableViewDataSource(data: NSData) {
        
        var hosts = [WSUserLocation]()
        
        // parse the json
        if let json = WSRequest.jsonDataToDictionary(data) {
            if let accounts = json["accounts"] as? NSDictionary {
                for (_, account) in accounts {
                    if let user = WSUserLocation(json: account) {
                        hosts.append(user)
                    }
                }
            }
        }
        
        hostsInTable = hosts
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    // Updates the pin clustering controller
    func updateClusteringController() {
        if self.hostsOnMap.count != 0 {
            clusteringController.setAnnotations(hostsOnMap)
            clusteringController.refresh(true)
        }
    }
    
    
    // MARK: - Map source methods
    
    // changes the map source
    func switchToMapSource(source: MapSource) {
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
        performSegueWithIdentifier(TO_USER_ACCOUNT_SEGUE_ID, sender: nil)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        switch identifier {
        case TO_USER_ACCOUNT_SEGUE_ID:
            print(sender is KPAnnotation)
            return sender is KPAnnotation
        case TO_HOST_LIST_SEGUE_ID:
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
            
        case TO_USER_ACCOUNT_SEGUE_ID:
            
            let navVC = segue.destinationViewController as! UINavigationController
            let accountTVC = navVC.viewControllers.first as! AccountTableViewController
            
            if let kpAnnotation = sender as? KPAnnotation {
                let userLocation = kpAnnotation.annotations.first as? WSUserLocation
                accountTVC.uid = userLocation?.uid
            } else {
                let uid = defaults.integerForKey(DEFAULTS_KEY_UID)
                accountTVC.uid = uid
            }
            
        case TO_HOST_LIST_SEGUE_ID:
            
            let kpAnnotation = sender as! KPAnnotation
            let users = Array(kpAnnotation.annotations) as! [WSUserLocation]
            let navVC = segue.destinationViewController as! UINavigationController
            let hostListTVC = navVC.viewControllers.first as! HostListTableViewController
            hostListTVC.users = users

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
