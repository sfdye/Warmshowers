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
    @IBOutlet var statusLabel: WSMapLabel!
    
    var navigationDelegate: WSHostSearchNavigationDelegate?
    var clusterController: CCHMapClusterController!
    var mapOverlay: MKTileOverlay?
    var mapSource: WSMapSource = WSMapSource.appleMaps
    
    /** Map tiles that have host downloads in progress. */
    var downloadsInProgress = Set<WSMapTile>()
    
    /** Tiles currently been displayed on the map. */
    var displayTiles = Set<WSMapTile>()
    
    
    // MARK: Constants
    
    let locationManager = CLLocationManager()
    
    // The maximum number of tiles that can be on the screen for downloads to start.
    let minimumUpdateZoomLevel: UInt = 6
    
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
//        toolbar.backgroundColor = .clear
//        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
//        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        // Ask the users permission to use location services.
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.none, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        assert(navigationDelegate != nil, "The navigation delegate for WSLocationSearchViewController not set. Please ensure the delegate is set before the view appears.")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        DispatchQueue.main.async(execute: { [weak self] in
            self?.mapView.showsUserLocation = CLLocationManager.authorizationStatus() == .authorizedWhenInUse
            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dump the display tiles and annotations the reload
        displayTiles = Set<WSMapTile>()
        clusterController.removeAnnotations(Array(clusterController.annotations), withCompletionHandler: nil)
        mapView.delegate?.mapView!(mapView, regionDidChangeAnimated: false)
    }
    
    
    // MARK: Utility methods
    
    /** Refreshes the status label according to the current controller state. */
    func updateStatus() {
        DispatchQueue.main.async(execute: { [weak self] in
            let text = self?.textForStatusLabel()
            self?.statusLabel.text = text
            self?.statusLabel.isHidden = text == nil
            })
    }
    
    /** Provides the string for the status label based on the current controller state. */
    func textForStatusLabel() -> String? {
        
        if zoomLevel < minimumUpdateZoomLevel {
            return "Please zoom in to update."
        }
        
        if downloadsInProgress.count > 0 {
            var highDensityArea = false
            for tile in downloadsInProgress {
                if tile.z.distance(to: minimumUpdateZoomLevel) > 1 {
                    highDensityArea = true
                }
            }
            if highDensityArea {
                return "Updating ...\nThere are a lot of hosts in this area so this update may take a while."
            } else {
                return "Updating ..."
            }
        }
        
        return nil
    }
    
    /** Returns the tiles in the current view that are known to have less than the maximum number of users on them. */
    func tilesInMapRegion(_ region: MKCoordinateRegion) -> Set<WSMapTile>? {
        guard !region.center.latitude.isNaN && !region.center.longitude.isNaN else { return nil }
        
        // The map tiles at the coarsest zoom level
        guard var parentTiles = WSMapTile.tilesForMapRegion(mapView.region, atZoomLevel: minimumUpdateZoomLevel) else {
            return nil
        }
        
        var tiles = Set<WSMapTile>()
        store.managedObjectContext.performAndWait { 
            while parentTiles.count > 0 {
                let tile = parentTiles.first!
                
                // Check for a saved tile. If there is none transfer the tile to the returned tiles.
                let predicate = NSPredicate(format: "%K like %@", "quad_key", tile.quadKey)
                guard let storedTile = try? self.store.retrieve(objectsWithClass: WSMOMapTile.self, sortBy: nil, isAscending: true, predicate: predicate, context: self.store.managedObjectContext).first else {
                    tiles.insert(tile)
                    parentTiles.remove(tile)
                    continue
                }
                
                // Check if the saved tile has sub-tiles. If it does, add the sub tiles to the parent tiles set so that they are checked for sub-tiles. Else, add the tile to the returned tiles.
                if let subtiles = storedTile?.sub_tiles , subtiles.count > 0 {
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
    func loadAnnotationsForMapTile(_ tile: WSMapTile) {
        
        func shouldDownloadHostsForMapTileMapTile(_ tile: WSMapTile) -> Bool {
            var storeNeedsUpdating = true
            var firstDownload = true
            let predicate = NSPredicate(format: "%K like %@", "quad_key", tile.quadKey)
            if let storedTile = try! store.retrieve(objectsWithClass: WSMOMapTile.self, sortBy: nil, isAscending: true, predicate: predicate, context: store.managedObjectContext).first {
                storeNeedsUpdating = storedTile.needsUpdating()
                firstDownload = storedTile.users == nil
            }
            return storeNeedsUpdating && (firstDownload || tile.z <= zoomLevel)
        }
        
        /** Returns the users on a given map tile from the store. */
        func storedUsersForMapTile(_ tile: WSMapTile) -> Set<WSUserLocation> {
            var users = Set<WSUserLocation>()
            let predicate = NSPredicate(format: "%K like %@", "quad_key", tile.quadKey)
            if let storedTile = try! store.retrieve(objectsWithClass: WSMOMapTile.self, sortBy: nil, isAscending: true, predicate: predicate, context: store.managedObjectContext).first {
                users = storedTile.userLocations ?? Set<WSUserLocation>()
            }
            return users
        }
        
        // Only reload the tile data if the displayed data is old.
        let displayTile = displayTiles.filter({ (aTile) -> Bool in
            return aTile.quadKey == tile.quadKey
        }).first
        guard displayTile?.needsUpdating ?? true else {
//            print("Tile already on map")
            return }
        
        // Stop here if there is already a download in progress for this tile.
        let downloadTile = downloadsInProgress.filter({ (aTile) -> Bool in
            return aTile.quadKey == tile.quadKey
        }).first
        guard downloadTile == nil else {
//            print("Download already started.")
            return
        }
        
        // If there is no exisiting tile, or the exiting tile needs updateing, start a download. Otherwise load the host location data from the store.
        // Note: If no tile is existing, one will be created by the end point descriptor when data is recieved.
        if shouldDownloadHostsForMapTileMapTile(tile) {
            // Grey the tile with an overlay and start a download.
//            print("Updating online.")
            if !downloadsInProgress.contains(tile) {
                downloadWillStartForMapTile(tile)
                api.contact(endPoint: .SearchByLocation, withPathParameters: nil, andData: tile, thenNotify: self)
            }
        } else {
//            print("Loading from the store.")
            // Add users from the store to the map
            
            tile.users = storedUsersForMapTile(tile)
            
            // Remove old map tile.
            if displayTiles.contains(tile) {
                displayTiles.remove(tile)
            }
            
            // Add new/updated map tile
            displayTiles.insert(tile)
            
            updateAnnotationsFromDisplayTiles(displayTiles)
        }
    }
    
    /** Unloads unrequired annotation from the map. */
    func unloadAnnotationsOutOfRegion(_ region: MKCoordinateRegion) {
        
        // Create a buffer region around the viewed region that is proportional to the zoom level.
        let regionMultiplier = 1.0 + Double(zoomLevel)
        var bufferRegion = region
        bufferRegion.span.latitudeDelta = bufferRegion.span.latitudeDelta * regionMultiplier
        bufferRegion.span.longitudeDelta = bufferRegion.span.longitudeDelta * regionMultiplier

        // Clear out display tiles that are not in this buffer region.
        let tilesNotInViewAndOld = displayTiles.filter { (tile) -> Bool in
            return !tile.isInRegion(bufferRegion) && tile.needsUpdating
        }
        
        for tile in tilesNotInViewAndOld {
            displayTiles.remove(tile)
        }
        
        updateAnnotationsFromDisplayTiles(displayTiles)
    }
    
    /** Updates the annotations grouped by the cluster controller with those in the current display tiles. */
    func updateAnnotationsFromDisplayTiles(_ displayTiles: Set<WSMapTile>) {
        
        // Update the cluster controllers
        var annotationsToDisplay = Set<WSUserLocation>()
        for tile in displayTiles {
            annotationsToDisplay.formUnion(tile.users)
        }
        
        let annotationsToRemove = clusterController.annotations.subtracting(annotationsToDisplay as Set<NSObject>)
        let annotationToAdd = (annotationsToDisplay as Set<NSObject>).subtracting(clusterController.annotations as Set<NSObject>)
        
        DispatchQueue.main.async(execute: { [weak self] in
            self?.clusterController.removeAnnotations(Array(annotationsToRemove), withCompletionHandler: {
                self?.clusterController.addAnnotations(Array(annotationToAdd), withCompletionHandler: nil)
            })
            })
    }
    
    /** Called just before an API request for user locations on the given map tile is made. */
    func downloadWillStartForMapTile(_ tile: WSMapTile) {
        downloadsInProgress.insert(tile)
        dimUpdatingTiles()
    }
    
    /** Called after a user locations API request has finished. */
    func downloadDidEndForMapTile(_ tile: WSMapTile) {
        downloadsInProgress.remove(tile)
        dimUpdatingTiles()
        DispatchQueue.main.async { [weak self] in
            self?.statusLabel.text = self?.textForStatusLabel()
        }
    }
    
    /** Dims areas of the map that have user location data downloads in progress. Tiles are only dimmed at the minimum update zoom level. */
    func dimUpdatingTiles() {
        
        // Get all the tiles to dim at the minimum update zoom level
        var tilesToDim = Set<WSMapTile>()
        for tile in downloadsInProgress {
            tilesToDim.insert(tile.parentAtZoomLevel(minimumUpdateZoomLevel)!)
        }
        
        // Dim all of these tiles if they are not dimmed already.
        for tile in tilesToDim {
            let existingOverlay = mapView.overlays.filter { (overlay) -> Bool in
                return overlay.title ?? "" == tile.quadKey
            }.first
            guard existingOverlay == nil else { continue }
            let polygon = tile.polygon()
            polygon.title = tile.quadKey
            mapView.performSelector(onMainThread: #selector(MKMapView.add(_:)), with: polygon, waitUntilDone: true)
        }
        
        // Undim any tiles not it this set.
        for overlay in mapView.overlays {
            guard let quadKey = overlay.title else { continue }
            guard let _ = tilesToDim.filter({ (tile) -> Bool in
                return tile.quadKey == quadKey
            }).first else {
                mapView.performSelector(onMainThread: #selector(MKMapView.remove(_:)), with: overlay, waitUntilDone: false)
                continue
            }
        }
    }
    
    /** The zoom level of the mapView. */
    var zoomLevel: UInt {
        var z: UInt = 1
        let mapSpan = min(mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta)
        while 360 / pow(2, Double(z)) > mapSpan {
            z += 1
        }
        return z
    }

}
