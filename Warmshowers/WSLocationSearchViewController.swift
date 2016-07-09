//
//  WSLocationSearchViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit
import CCHMapClusterController

class WSLocationSearchViewController : UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var statusLabel: UILabel!
    
    var navigationDelegate: WSHostSearchNavigationDelegate?
    var clusterController: CCHMapClusterController!
    var downloadsInProgress = Set<WSMapTile>()
    
    /** Convenience variable to returns the tiles in the current view. */
    var tilesInView: [WSMapTile]? {
        return WSMapTile.tilesForMapRegion(mapView.region, atZoomLevel: TileUpdateZoomLevel)
    }
    
    var mapOverlay: MKTileOverlay?
    var mapSource: WSMapSource = WSMapSource.AppleMaps
    
    // MARK: Constants
    
    let locationManager = CLLocationManager()
    
    // This is the zoom level at which api request will be made
    let TileUpdateZoomLevel: UInt = 5
    
    // The level of dimming for tiles that are updating. A value between 0 and 1.
    let dimLevel: CGFloat = 0.3
    
//    // This is the minimum zoom level at which tiles should be updated.
//    let MinimumZoomLevelForTileUpdates: UInt = 5
//    
//    // This is the minimum zoom level that annotation will be shown
//    let MinimumZoomLevelToShowAnnotations: UInt = 2
    
    // Delegates
    var alert: WSAlertDelegate = WSAlertDelegate.sharedAlertDelegate
    var api: WSAPICommunicator = WSAPICommunicator.sharedAPICommunicator
    var store: WSStoreMapTileProtocol = WSStore.sharedStore
    
    override func viewDidLoad() {
        clusterController = CCHMapClusterController(mapView: mapView)
        clusterController.delegate = self
        configureToolbar()
        statusLabel.text = nil
        
        // Ask the users permission to use location services.
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.showsUserLocation = true
        centerOnRegion()
    }
    
    override func viewWillAppear(animated: Bool) {
        assert(navigationDelegate != nil, "The navigation delegate for WSLocationSearchViewController not set. Please ensure the delegate is set before the view appears.")
    }
    
    override func viewDidAppear(animated: Bool) {
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.showsUserLocation = CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse
    }
    
    func configureToolbar() {
        // This fix removes a shadow line from the top of the toolbar.
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .Any, barMetrics: .Default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .Any)
    }
    
    // MARK: Utility methods
    
    /** Centres the map on the region around the users location at a set zoom level. */
    func centerOnRegion() {
        let DefaultRegionLatitudeDelta: CLLocationDegrees = 1
        let DefaultRegionLongitudeDelta: CLLocationDegrees = 1
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: DefaultRegionLatitudeDelta, longitudeDelta: DefaultRegionLongitudeDelta))
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                self?.mapView.setRegion(region, animated: true)
                })
        }
    }
    
    /** Provides the string for the status label based on the current controller state. */
    func textForStatusLabel() -> String? {
        
        if let tiles = tilesInView where tiles.count > 0 {
            return "Please zoom in to update."
        }
        
        if downloadsInProgress.count > 0 {
            return "Updating ..."
        }
        
        return nil
    }
    
    /** Removes all user location annotations from the map that aren't on the given map tiles. */
    func clearAnnotationsNotOnMapTiles(tiles: [WSMapTile]) {
        
        let quadKeys = tiles.map { (tile) -> String in return tile.quadKey }
        let unrequiredAnnotations = mapView.annotations.filter { (annotation) -> Bool in
            if annotation is WSUserLocation {
                if let tileID = (annotation as! WSUserLocation).tileID {
                    return !quadKeys.contains(tileID)
                }
            }
            return false
        }
        
        print("\(unrequiredAnnotations.count) / \(mapView.annotations.count) being removed from the map.")
        
        if unrequiredAnnotations.count > 0 {
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                self?.clusterController.removeAnnotations(unrequiredAnnotations, withCompletionHandler: nil)
                })
        }
        
        print("\(mapView.annotations.count) remaining.")
    }
    
    /** Downloads user locations for the given map tiles and adds them as annotations to the map. */
    func loadAnnotationsForMapTiles(tiles: [WSMapTile]) {
        
        for tile in tiles {
            if store.hasValidHostDataForMapTile(tile) {
                // Add users from the store to the map
                print("Loading users from the store.")
                let users = store.usersForMapTile(tile)
                addUsersToMap(users)
            } else {
                // Grey the tile with an overlay and start a download.
                print("Requesting users from the api.")
                downloadWillStartForMapTile(tile)
                api.searchByLocation(tile, andNotify: self)
            }
        }
    }
    
    /** Addes user annotations to the map. */
    func addUsersToMap(users: [WSUserLocation]?) {
        guard let users = users else { return }
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            self?.clusterController.addAnnotations(users, withCompletionHandler: nil)
            })
    }
    
    /** Called just before an API request for user locations on the given map tile is made. */
    func downloadWillStartForMapTile(tile: WSMapTile) {
        downloadsInProgress.insert(tile)
        dimTiles()
    }
    
    /** Called after a user locations API request has finished. */
    func downloadDidEndForMapTile(tile: WSMapTile) {
        downloadsInProgress.remove(tile)
        dimTiles()
    }
    
    /** Dims areas of the map that have user location data downloads in progress. */
    func dimTiles() {
        mapView.performSelectorOnMainThread(#selector(MKMapView.removeOverlays(_:)), withObject: mapView.overlays, waitUntilDone: true)
        for tile in downloadsInProgress {
            dimTile(tile)
        }
    }
    
    /** Adds a dimming overlay to the map area described by the given map tile. */
    func dimTile(tile: WSMapTile) {
        let polygon = tile.polygon()
        polygon.title = tile.quadKey
        mapView.performSelectorOnMainThread(#selector(MKMapView.addOverlay(_:)), withObject: polygon, waitUntilDone: false)
    }

}
