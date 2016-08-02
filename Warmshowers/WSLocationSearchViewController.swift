//
//  WSLocationSearchViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CCHMapClusterController

class WSLocationSearchViewController : UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var statusLabel: UILabel!
    
    var navigationDelegate: WSHostSearchNavigationDelegate?
    var clusterController: CCHMapClusterController!
    var mapOverlay: MKTileOverlay?
    var mapSource: WSMapSource = WSMapSource.AppleMaps
    
    /** Map tiles that have host downloads in progress. */
    var downloadsInProgress = Set<WSMapTile>()
    
    /** Tiles currently been displayed on the map. */
    var displayTiles = Set<WSMapTile>()
    
    
    // MARK: Constants
    
    let locationManager = CLLocationManager()
    
    // This is the zoom level at which api request will be made. i.e. each api request will be for the area specified at this zoom level.
    let tileUpdateZoomLevel: UInt = 5
    
    // The maximum number of tiles that can be on the screen for downloads to start.
    let maximumTilesInViewForUpdate = 20
    
    // The maximum number of users per map tile.
    let maximumUsersPerTile = WSSearchByLocationEndPoint.MapSearchLimit
    
    // The level of dimming for tiles that are updating. A value between 0 and 1.
    let dimLevel: CGFloat = 0.3

    
    // Delegates
    var alert: WSAlertDelegate = WSAlertDelegate.sharedAlertDelegate
    var api: WSAPICommunicator = WSAPICommunicator.sharedAPICommunicator
    var store: WSStoreProtocol = WSStore.sharedStore
    
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
    
    /** Refreshes the status label according to the current controller state. */
    func updateStatus() {
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            self?.statusLabel.text = self?.textForStatusLabel()
            })
    }
    
    /** Provides the string for the status label based on the current controller state. */
    func textForStatusLabel() -> String? {
        
        if let tiles = tilesInMapRegion(mapView.region) where tiles.count > 20 {
            return "Please zoom in to update."
        }
        
        if downloadsInProgress.count > 0 {
            return "Updating ..."
        }
        
        return nil
    }
    
    /** Returns the tiles in the current view that are known to have less than the maximum number of users on them. */
    func tilesInMapRegion(region: MKCoordinateRegion) -> Set<WSMapTile>? {
        guard !region.center.latitude.isNaN && !region.center.longitude.isNaN else { return nil }
        
        // The map tiles at the coarsest zoom level
        guard var parentTiles = WSMapTile.tilesForMapRegion(mapView.region, atZoomLevel: tileUpdateZoomLevel) else {
            return nil
        }
        
        var tiles = Set<WSMapTile>()
        store.managedObjectContext.performBlockAndWait { 
            while parentTiles.count > 0 {
                let tile = parentTiles.first!
                
                // Check for a saved tile. If there is none transfer the tile to the returned tiles.
                
                let predicate = NSPredicate(format: "%K like %@", "quad_key", tile.quadKey)
                guard let storedTile = try? self.store.retrieve(WSMOMapTile.self, sortBy: nil, isAscending: true, predicate: predicate, context: self.store.managedObjectContext).first else {
                    tiles.insert(tile)
                    parentTiles.remove(tile)
                    continue
                }
                
                // Check if the saved tile has sub-tiles. If it does, add the sub tiles to the parent tiles set so that they are checked for sub-tiles. Else, add the tile to the returned tiles.
                if let subtiles = storedTile?.sub_tiles where subtiles.count > 0 {
                    for subtile in tile.subtiles {
                        parentTiles.insert(subtile)
                    }
                    parentTiles.remove(tile)
                } else {
                    tiles.insert(tile)
                    parentTiles.remove(tile)
                }
            }
        }
        return tiles
    }
    
    /** Downloads user locations for the given map tiles and adds them as annotations to the map. */
    func loadAnnotationsForMapTile(tile: WSMapTile) {
        
        /** Checks if the store is up-to-date for a given map tile. */
        func storeNeedsUpdatingForMapTile(tile: WSMapTile) -> Bool {
            var storeNeedsUpdate = true
            let predicate = NSPredicate(format: "%K like %@", "quad_key", tile.quadKey)
            if let storedTile = try! store.retrieve(WSMOMapTile.self, sortBy: nil, isAscending: true, predicate: predicate, context: store.managedObjectContext).first {
                storeNeedsUpdate = storedTile.needsUpdating()
            }
            return storeNeedsUpdate
        }
        
        /** Returns the users on a given map tile from the store. */
        func storedUsersForMapTile(tile: WSMapTile) -> Set<WSUserLocation> {
            var users = Set<WSUserLocation>()
            let predicate = NSPredicate(format: "%K like %@", "quad_key", tile.quadKey)
            if let storedTile = try! store.retrieve(WSMOMapTile.self, sortBy: nil, isAscending: true, predicate: predicate, context: store.managedObjectContext).first {
                users = storedTile.userLocations ?? Set<WSUserLocation>()
            }
            return users
        }
        
        // Only reload the tile data if the displayed data is old.
        let displayTile = displayTiles.filter({ (aTile) -> Bool in
            return aTile.quadKey == tile.quadKey
        }).first
        guard displayTile?.needsUpdating ?? true else { return }
        
        // If there is no exisiting tile, or the exiting tile needs updateing, start a download. Otherwise load the host location data from the store.
        // Note: If no tile is existing, one will be created by the end point descriptor when data is recieved.
        if storeNeedsUpdatingForMapTile(tile) {
            // Grey the tile with an overlay and start a download.
            
            if !downloadsInProgress.contains(tile) {
                downloadWillStartForMapTile(tile)
                api.contactEndPoint(.SearchByLocation, withPathParameters: nil, andData: tile, thenNotify: self)
            }
        } else { 
            // Add users from the store to the map
            
            tile.users = storedUsersForMapTile(tile)
            tile.last_updated = NSDate()
            
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
                self?.clusterController.removeAnnotations(Array(oldAnnotations), withCompletionHandler: nil)
                self?.clusterController.addAnnotations(Array(newAnnoations), withCompletionHandler: nil)
                })
        }
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
