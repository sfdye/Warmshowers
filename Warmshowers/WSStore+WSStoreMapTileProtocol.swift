//
//  WSStore+MapTile.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

extension WSStore { // : WSStoreMapTileProtocol {
    
//    /** This expiry time controls when host location records are removed from the store due to not being used. */
//    var MapTileExpiryTime: NSTimeInterval { return 60.0 * 60.0 * 24.0 }
//    
//    func allMapTiles() throws -> [WSMOMapTile] {
//        
//        do {
//            let tiles = try getAllEntriesFromEntity(.MapTile) as! [WSMOMapTile]
//            return tiles
//        }
//    }
//    
//    func mapTileWithQuadKey(quadKey: String) throws -> WSMOMapTile? {
//        
//        let request = requestForEntity(.MapTile)
//        request.predicate = NSPredicate(format: "%K like %@", "quad_key", quadKey)
//        
//        do {
//            let tile = try executeFetchRequest(request).first as? WSMOMapTile
//            return tile
//        }
//    }
//    
//    func newOrExistingMapTileWithQuadKey(quadKey: String) throws -> WSMOMapTile {
//        
//        do {
//            if let tile = try mapTileWithQuadKey(quadKey) {
//                return tile
//            } else {
//                let tile = NSEntityDescription.insertNewObjectForEntityForName(WSEntity.MapTile.rawValue, inManagedObjectContext: privateContext) as! WSMOMapTile
//                tile.quad_key = quadKey
//                return tile
//            }
//        }
//    }
//    
//    func hasValidHostDataForMapTile(tile: WSMapTile) -> Bool {
//        
//        do {
//            let storedTile = try mapTileWithQuadKey(tile.quadKey)
//            return !(storedTile?.needsUpdating() ?? true)
//        } catch {
//            return false
//        }
//    }
//    
//    func usersForMapTile(tile: WSMapTile) -> [WSUserLocation] {
//        
//        if let storedTile = try? mapTileWithQuadKey(tile.quadKey) {
//            return storedTile?.userLocations ?? [WSUserLocation]()
//        } else {
//            return [WSUserLocation]()
//        }
//    }
//    
//    func clearoutOldTiles() {
//        do {
//            let tiles = try allMapTiles()
//            for tile in tiles {
//                if let last_updated = tile.last_updated {
//                    if abs(last_updated.timeIntervalSinceNow) > MapTileExpiryTime {
//                        privateContext.deleteObject(tile)
//                    }
//                }
//            }
//        } catch {
//            // Error clearing out old tiles
//        }
//    }
//    
//    func clearoutAllTiles() {
//        do {
//            let tiles = try allMapTiles()
//            for tile in tiles {
//                privateContext.deleteObject(tile)
//                try savePrivateContext()
//            }
//        } catch {
//            // Error clearing out map tiles
//        }
//    }
    
}