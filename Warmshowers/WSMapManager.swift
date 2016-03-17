//
//  WSMapManager.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CCHMapClusterController

class WSMapManager : NSObject {
    
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
//    var delegate: WSMapManagerDelegate?
    
    // MARK: Initialiser
    
    init(withMapView mapView: MKMapView) {
        self.mapView = mapView
        self.clusteringController = CCHMapClusterController(mapView: mapView)
        super.init()
        self.clusteringController.delegate = self
    }
    
    // MARK: Tile checking and updating utilities
    
    // Returns the tiles at the update zoom level currently in the view
    func tilesInViewForUpdateZoomLevel() -> [CDWSMapTile] {
        
        // Convert a longitude to a x value. x = 0 @ Lon = -180, y = 360 @ Lon = 180
        func longitudeToX(var longitude: Double) -> Double {
            
            // Offset so that x is in the range of 0-360
            longitude += 180
            
            // Ensure the longitude is in the range of 0-360
            while longitude < 0 {
                longitude += 360
            }
            while longitude > 360 {
                longitude -= 360
            }
            
            return longitude
        }
        
        // Convert a latitude to a y value. y = 0 @ Lat = 90, y = 180 @ Lat = -90
        func latitudeToY(var latitude: Double) -> Double {
            
            // Offset so that y is in the range of -180-0
            latitude -= 90
            
            // Ensure the latitude is in the range of -180-0
            while latitude < -180 {
                latitude += 180
            }
            while latitude > 0 {
                latitude -= 180
            }
            
            // Return the negated scale
            return -latitude
        }
        
        // Tile size
        let deltaX = 360.0 / pow(2.0, Double(TileUpdateZoomLevel))
        let deltaY = 180.0 / pow(2.0, Double(TileUpdateZoomLevel))
        
        // View limits in the (x,y) system
        let minX = longitudeToX(mapView.minimumLongitude)
        let maxX = longitudeToX(mapView.maximumLongitude)
        let minY = latitudeToY(mapView.maximumLatitude)
        let maxY = latitudeToY(mapView.minimumLatitude)
        
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
    
    // Updates an array of map tiles
    //
    func updateMapTiles(tiles: [CDWSMapTile]) {
        
        for tile in tiles {
//            mapView.addOverlay(tile.polygon())
            updateMapTile(tile)
        }
    }

    //  Starts an update request for a map tile
    //
    func updateMapTile(tile: CDWSMapTile) {
        
        let tileID = tile.identifierFromXYZ
        
        if shouldUpdateMapTile(tile) {
            
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
    
    // Removes the message updater object assign to a given thread and reloads the table if all updates are done
    //
    func updateFinishedMapTileID(tileID: String) {
        
        // Remove the updater
        self.updatesInProgress.removeValueForKey(tileID)
        
        // Update the annotations
        
        do {
            print("fetching host data for tileID: \(tileID)")
            if let tile = try WSStore.mapTileWithID(tileID) {
                print(tile)
                addAnnotationsFromMapTile(tile)
            } else {
                print("Couldn't find tile in the store")
            }
        } catch {
            print("An error occured fetching a tile by id from the store.")
        }
        
        // Reload the table view if all the updates are finished
//        if updatesInProgress.count == 0 {
//            self.finishedUpdates()
//        }
    }
    
    // Cancels all message update requests
    //
    func cancelAllUpdates() {
        for (_, update) in updatesInProgress {
            update.cancel()
        }
    }
    
    // Removes all pins from the map
    //
    func removeAllAnnotations() {
        clusteringController.removeAnnotations(Array(clusteringController.annotations), withCompletionHandler: nil)
    }
    
    // Adds host location annotations to the map
    //
    func addAnnotationsFromMapTiles(tiles: [CDWSMapTile]) {
        for tile in tiles {
            addAnnotationsFromMapTile(tile)
        }
    }

    func addAnnotationsFromMapTile(tile: CDWSMapTile) {
        if let users = tile.users where users.count > 0 {
            print("adding \(users.count) users to the map")
            var locations = [WSUserLocation]()
            let tileID = tile.identifier!
            for user in users {
                if let location = WSUserLocation(user: user as! CDWSUser, tileID: tileID) {
                    locations.append(location)
                }
            }
            clusteringController.addAnnotations(locations, withCompletionHandler: nil)
            print("added \(users.count) locations to cc")
        }
    }
    
    // Loads host location annotations for the current view
    //
    func updateAnnotationsInView() {
        
        // Remove annotation if the user zooms out too far
        guard mapView.zoomLevel() > MinimumZoomLevelToShowAnnotations else {
            removeAllAnnotations()
            return
        }
        
        // Load the current data and update the data if needed
        let tiles = tilesInViewForUpdateZoomLevel()
        addAnnotationsFromMapTiles(tiles)
        
        // Do nothing when the user is zoomed out too far
        guard mapView.zoomLevel() >= MinimumZoomLevelForTileUpdates else {
            print("MAP UPDATE: Zoomed out to level: \(mapView.zoomLevel()), supressing updates.")
            return
        }
        
        // Cancel any out-of-view updates
        // TODO
        
        // Update host location data on the visible tiles
        updateMapTiles(tiles)
    }
}