//
//  WSMapController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CCHMapClusterController

class WSMapController : NSObject {
    
    // This is the zoom level at which api request will be made
    let TileUpdateZoomLevel: UInt = 5
    
    // This is the minimum zoom level at which tiles should be updated.
    // If the map is zoom out to less than this zoom level updateTilesInView() will do nothing
    let MinimumZoomLevelForTileUpdates: UInt = 5
    
    // This is the minimum zoom level that annotation will be shown
    // When the user is zoomed out too far it doesn't make sense to try and show map pins
    let MinimumZoomLevelToShowAnnotations: UInt = 2
    
    var mapView: MKMapView!
    var clusteringController: CCHMapClusterController!
    var updatesInProgress = [String: WSHostsOnMapSearchManager]()
    var delegate: WSMapControllerDelegate?
    
    // MARK: Initialiser
    
    init(withMapView mapView: MKMapView) {
        self.mapView = mapView
        self.clusteringController = CCHMapClusterController(mapView: mapView)
        super.init()
        self.clusteringController.delegate = self
    }
    
    // MARK: Tile updating methods
    
    /// Returns the tiles at the update zoom level currently in the view
    func tilesInViewForUpdateZoomLevel() -> [CDWSMapTile] {
        
        // Convert a longitude to a x value. x = 0 @ Lon = -180, y = 360 @ Lon = 180
        func longitudeToX(longitude: Double) -> Double {
            
            // Offset so that x is in the range of 0-360
            var lon = longitude + 180
            
            // Ensure the longitude is in the range of 0-360
            while lon < 0 {
                lon += 360
            }
            while lon > 360 {
                lon -= 360
            }
            
            return lon
        }
        
        // Convert a latitude to a y value. y = 0 @ Lat = 90, y = 180 @ Lat = -90
        func latitudeToY(latitude: Double) -> Double {
            
            // Offset so that y is in the range of -180-0
            var lat = latitude - 90
            
            // Ensure the latitude is in the range of -180-0
            while lat < -180 {
                lat += 180
            }
            while lat > 0 {
                lat -= 180
            }
            
            // Return the negated scale
            return -lat
        }
        
        // Tile size
        let deltaX = 360.0 / pow(2.0, Double(TileUpdateZoomLevel))
        let deltaY = 180.0 / pow(2.0, Double(TileUpdateZoomLevel))
        
        // View limits in the (x,y) system 
        // Half the view area is added as a buffer region
        let mapRegionBufferFactor = 1.2
        let minX = longitudeToX(mapView.minimumLongitude - deltaX * mapRegionBufferFactor)
        let maxX = longitudeToX(mapView.maximumLongitude + deltaX * mapRegionBufferFactor)
        let minY = latitudeToY(mapView.maximumLatitude + deltaY * mapRegionBufferFactor)
        let maxY = latitudeToY(mapView.minimumLatitude - deltaY * mapRegionBufferFactor)
        
        // Generate arrays of the tile indexes in the view
        var xTileIndexes: [UInt]
        if minX < maxX {
            xTileIndexes = Array(UInt(minX / deltaX) ... UInt(maxX / deltaX))
        } else {
            let maxXIndex = UInt(pow(2.0, Double(TileUpdateZoomLevel)) - 1)
            let first = Set(0 ... UInt(maxX / deltaX))
            let last = Set(UInt(minX / deltaX) ... maxXIndex)
            xTileIndexes = Array(first.union(last))
        }
        
        var yTileIndexes: [UInt]
        if minY < maxY {
            yTileIndexes = Array(UInt(minY / deltaY) ... UInt(maxY / deltaY))
        } else {
            let maxYIndex = UInt(pow(2.0, Double(TileUpdateZoomLevel)) - 1)
            let first = Set(0 ... UInt(maxY / deltaY))
            let last = Set(UInt(minY / deltaY) ... maxYIndex)
            yTileIndexes = Array(first.union(last))
        }
        
        print("Tiles in view: x: [\(xTileIndexes)], y: [\(yTileIndexes)]")
        
        // Return all the tiles in the view
        var tiles = [CDWSMapTile]()
        for y in yTileIndexes {
            for x in xTileIndexes {
                do {
                    let tile = try WSStore.newOrExistingMapTileAtPosition(x, y: y, z: TileUpdateZoomLevel)
                    tiles.append(tile)
                } catch {
                    print("Failed to get tiles from the store.")
                }
            }
        }
        
        return tiles
    }

    ///  Starts an update request for a map tile
    func updateMapTile(tile: CDWSMapTile) {
        
        let tileID = tile.identifierFromXYZ
        
        if shouldUpdateMapTile(tile) {
            
            if updatesInProgress.count == 0 {
                self.delegate?.willBeginUpdates()
            }
            
            print("updating tile")
            let updater = WSHostsOnMapSearchManager(
                success: { () -> Void in
                    self.updateFinishedMapTileID(tileID)
                },
                failure: { (error) -> Void in
                    print("fail: \(error.localizedDescription)")
                    self.updateFinishedMapTileID(tileID)
                }
            )
            let x = UInt(tile.x!)
            let y = UInt(tile.y!)
            let z = UInt(tile.z!)
            updater.updateHostsForTileAtPosition(x, y: y, z: z)
            updatesInProgress[tileID] = updater
            
        } else {
            if updatesInProgress[tileID] != nil {
                print("Tile update in progress")
            } else {
                print("Tile is up-to-date")
            }
        }
    }
    
    func shouldUpdateMapTile(tile: CDWSMapTile) -> Bool {
        return tile.needsUpdating() && updatesInProgress[tile.identifierFromXYZ] == nil
    }
    
    /// Removes the message updater object assign to a given thread and reloads the table if all updates are done
    func updateFinishedMapTileID(tileID: String) {
        
        // Remove the updater
        self.updatesInProgress.removeValueForKey(tileID)
        
        // Update the annotations
        do {
            if let tile = try WSStore.mapTileWithID(tileID) {
                addAnnotationsFromMapTile(tile)
            } else {
                print("Couldn't find tile in the store")
            }
        } catch {
            print("An error occured fetching a tile by id from the store.")
        }
        
        // Signal finshing updates
        if updatesInProgress.count == 0 {
            self.delegate?.didFinishUpdates()
        }
    }
    
    // Cancels all message update requests
    //
    func cancelAllUpdates() {
        for (_, update) in updatesInProgress {
            update.cancel()
        }
    }
    
    // MARK: Adding and removing annotations
    
    /// Removes all pins from the map
    func removeAllAnnotations() {
        clusteringController.removeAnnotations(Array(clusteringController.annotations), withCompletionHandler: nil)
    }
    
    func removeAnnotationsWithTileID(tileID: String) {
        
        let hostsOnTile = clusteringController.annotations.filter { (user) -> Bool in
            if let userTileID = user.valueForKey("tileID") {
                return userTileID.isEqualToString(tileID)
            } else {
                return false
            }
        }
        
        print("removing \(hostsOnTile.count) annotations")
        clusteringController.removeAnnotations(hostsOnTile, withCompletionHandler: nil)
    }
    
    /// Adds host location annotations to the map for an array of tiles
    func addAnnotationsFromMapTiles(tiles: [CDWSMapTile]) {
        for tile in tiles {
            addAnnotationsFromMapTile(tile)
        }
    }

    /// Adds host location annotations to the map for a single map tile
    func addAnnotationsFromMapTile(tile: CDWSMapTile) {
        if let users = tile.users where users.count > 0 {
            print("adding \(users.count) users to the map")
            var locations = [WSUserLocation]()
            let tileID = tile.identifier!
            for user in users {
                if let location = WSUserLocation(user: user as! CDWSUserLocation, tileID: tileID) {
                    locations.append(location)
                }
            }
            clusteringController.addAnnotations(locations, withCompletionHandler: nil)
        } else {
            print("Zero users on tile with id: \(tile.identifier)")
        }
    }
    
    /// Updates the annotation on the map with those from an array of tiles
    func updateAnnotationsWithMapTiles(tiles: [CDWSMapTile]) {
        
        // Remove all annotations that belong to other tiles
        removeAllAnnotations()
        
        // Update the annotations shown for each tile
        print("Adding annotation for \(tiles.count) to the map.")
        for tile in tiles {
            updateAnnotationsForMapTile(tile)
        }
    }
    
    func updateAnnotationsForMapTile(tile: CDWSMapTile) {
        
        // Remove all current annotations
        removeAnnotationsWithTileID(tile.identifier!)
        
        // Add the up-to-date ones
        addAnnotationsFromMapTile(tile)
    }
    
    /// Loads host location annotations for the current view
    func updateAnnotationsInView() {
        
        // Remove annotation if the user zooms out too far
        guard mapView.zoomLevel() > MinimumZoomLevelToShowAnnotations else {
            removeAllAnnotations()
            return
        }
        
        // Load the tiles in the view
        let tiles = tilesInViewForUpdateZoomLevel()
        
        highlightTiles(tiles)
        
        print("Removing annotations")
        removeAllAnnotations()
        
        print("Adding annotations")
        addAnnotationsFromMapTiles(tiles)
        
        // --- Updates ---
        
        // Do nothing when the user is zoomed out too far
        guard mapView.zoomLevel() >= MinimumZoomLevelForTileUpdates else {
            print("MAP UPDATE: Zoomed out to level: \(mapView.zoomLevel()), supressing updates.")
            return
        }
        
        print("Updating tiles")
        for tile in tiles {
            updateMapTile(tile)
        }
    }
    
    // MARK: Utilities
    
    func highlightTiles(tiles: [CDWSMapTile]) {
        // Add overlay for debug
        mapView.removeOverlays(mapView.overlays)
        for tile in tiles {
            mapView.addOverlay(tile.polygon())
        }
    }
    
    
    
}