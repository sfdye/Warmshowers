//
//  HostsViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

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

class HostMapViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var searchBar: UISearchBar!
    
    let httpClient = WSRequest()
    var alertController: UIAlertController?
    let locationManager = CLLocationManager()
    
    // Map source variables
    var mapSource = MapSource.AppleMaps
    var mapOverlay: MKTileOverlay? = nil
    var overlay: MKTileOverlay? = nil
    
    // Host data variables
    var hosts = [WSUserLocation]()
    
    // Navigation bar items
    let cancelButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: nil, action: nil)
    let accountButton = UIBarButtonItem.init()
    
    // Pin clustering controller
    private var clusteringController : KPClusteringController!
    
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allows the http client to diplay alerts through this view controller
        httpClient.alertViewController = self
        
        // Set up the navigation bar
        self.cancelButton.target = self
        self.cancelButton.action = Selector("cancelButtonPressed")
        self.accountButton.image = UIImage.init(named: "UserIcon")
        self.accountButton.target = self
        self.accountButton.action = Selector("accountButtonPressed")
        self.navigationItem.setLeftBarButtonItem(accountButton, animated: false)
        self.navigationItem.titleView = searchBar
        
        // Pin clustering
        let algorithm : KPGridClusteringAlgorithm = KPGridClusteringAlgorithm()
        algorithm.annotationSize = CGSizeMake(25, 50)
        algorithm.clusteringStrategy = KPGridClusteringAlgorithmStrategy.TwoPhase;
        clusteringController = KPClusteringController(mapView: self.mapView, clusteringAlgorithm: algorithm)
        clusteringController.delegate = self
        clusteringController.setAnnotations(hosts)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Ask the users permission to use location services
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.showsUserLocation = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Map update methods
    
    // Updates the hosts shown on the map
    func updateHostsOnMap() {
        
        httpClient.getHostDataForMapView(mapView) { (data) -> Void in
            
            // update the mapView data source
            if data != nil {
                let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                dispatch_async(queue, { () -> Void in
                    self.updateHostList(data!)
                })
            }
        }
    }
    
    // Adds hosts to the map with data from the web
    func updateHostList(data: NSData) {
        
        // parse the json
        if let json = self.httpClient.jsonDataToDictionary(data) {
            if let accounts = json["accounts"] as? NSArray {
                for account in accounts {
                    if let user = WSUserLocation.initWithObject(account) {
                        if !self.userOnMap(user.uid!) {
                            self.hosts.append(user)
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
    
    // Updates the pin clustering controller
    func updateClusteringController() {
        if self.hosts.count != 0 {
            clusteringController.setAnnotations(hosts)
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
    
    // MARK: Navigation bar item methods
    
    func cancelButtonPressed() {
        self.searchBar.resignFirstResponder()
    }
    
    func accountButtonPressed() {
        let accountTVC = storyboard?.instantiateViewControllerWithIdentifier("AccountNavigationController")
        if accountTVC != nil {
            self.presentViewController(accountTVC!, animated: true, completion: nil)
        }
    }
    
    
    // MARK: Utilities

    // Checks if a user is already in the map data source
    func userOnMap(uid: Int) -> Bool {
        
        for host in hosts {
            if host.uid == uid {
                return true
            }
        }
        return false
    }

}
