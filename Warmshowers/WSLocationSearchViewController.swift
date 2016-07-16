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
    var displayTiles = Set<WSMapTile>()
    
    /** Convenience variable to returns the tiles in the current view. */
    var tilesInView: [WSMapTile]? {
        return WSMapTile.tilesForMapRegion(mapView.region, atZoomLevel: tileUpdateZoomLevel)
    }
    
    var mapOverlay: MKTileOverlay?
    var mapSource: WSMapSource = WSMapSource.AppleMaps
    
    // MARK: Constants
    
    let locationManager = CLLocationManager()
    
    // This is the zoom level at which api request will be made.
    let tileUpdateZoomLevel: UInt = 5
    
    // The maximum number of tiles that can be on the screen for downloads to start.
    let maximumTilesInViewForUpdate = 20
    
    // The level of dimming for tiles that are updating. A value between 0 and 1.
    let dimLevel: CGFloat = 0.3

    
    // Delegates
    var alert: WSAlertDelegate = WSAlertDelegate.sharedAlertDelegate
    var api: WSAPICommunicator = WSAPICommunicator.sharedAPICommunicator
    var store: WSStoreMapTileProtocol = WSStore.sharedStore
    
    override func viewDidLoad() {
        clusterController = CCHMapClusterController(mapView: mapView)
        clusterController.delegate = self
        statusLabel.text = nil
        
        // This fix removes a shadow line from the top of the toolbar.
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .Any, barMetrics: .Default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .Any)
        
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
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            self?.mapView.showsUserLocation = CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse
            })
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
        
        if let tiles = tilesInView where tiles.count > 20 {
            return "Please zoom in to update."
        }
        
        if downloadsInProgress.count > 0 {
            return "Updating ..."
        }
        
        return nil
    }
    
    /** Downloads user locations for the given map tiles and adds them as annotations to the map. */
    func loadAnnotationsForMapTile(tile: WSMapTile) {

        if store.hasValidHostDataForMapTile(tile) {
            // Add users from the store to the map
            let users = store.usersForMapTile(tile)
            tile.users = users
            tile.last_updated = NSDate()
            addUsersToMapWithMapTile(tile)
        } else {
            // Grey the tile with an overlay and start a download.
            if !downloadsInProgress.contains(tile) {
                downloadWillStartForMapTile(tile)
                api.contactEndPoint(.SearchByLocation, withPathParameters: nil, andData: tile, thenNotify: self)
            }
        }
    }
    
    /** Addes user annotations to the map. */
    func addUsersToMapWithMapTile(tile: WSMapTile) {
        
        // Remove old map tile.
        if displayTiles.contains(tile) {
            displayTiles.remove(tile)
        }
        
        // Add new/updated map tile
        displayTiles.insert(tile)
        
        // Update the cluster controllers
        var newAnnoations = Set<WSUserLocation>()
        for tile in displayTiles {
            newAnnoations.unionInPlace(tile.users)
        }
        
        let oldAnnotations = clusterController.annotations
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            self?.clusterController.removeAnnotations(Array(oldAnnotations), withCompletionHandler: { })
            self?.clusterController.addAnnotations(Array(newAnnoations), withCompletionHandler: nil)
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
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            self?.statusLabel.text = self?.textForStatusLabel()
        }
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
