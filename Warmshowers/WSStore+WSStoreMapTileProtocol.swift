//
//  WSStore+MapTile.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

extension WSStore : WSStoreMapTileProtocol {
    
    var MapTileExpiryTime: TimeInterval { return 60.0 * 60.0 * 24.0 }
    
    func allMapTiles() throws -> [CDWSMapTile] {
        
        do {
            let tiles = try getAllEntriesFromEntity(.MapTile) as! [CDWSMapTile]
            return tiles
        }
    }
    
    func mapTileWithQuadKey(_ quadKey: String) throws -> CDWSMapTile? {
        
        let request = requestForEntity(.MapTile)
        request.predicate = Predicate(format: "%K like %@", "quad_key", quadKey)
        
        do {
            let tile = try executeFetchRequest(request).first as? CDWSMapTile
            return tile
        }
    }
    
    func newOrExistingMapTileWithQuadKey(_ quadKey: String) throws -> CDWSMapTile {
        
        do {
            if let tile = try mapTileWithQuadKey(quadKey) {
                return tile
            } else {
                let tile = NSEntityDescription.insertNewObject(forEntityName: WSEntity.MapTile.rawValue, into: privateContext) as! CDWSMapTile
                tile.quad_key = quadKey
                return tile
            }
        }
    }
    
    func hasValidHostDataForMapTile(_ tile: WSMapTile) -> Bool {
        
        do {
            let storedTile = try mapTileWithQuadKey(tile.quadKey)
            return !(storedTile?.needsUpdating() ?? true)
        } catch {
            return false
        }
    }
    
    func usersForMapTile(_ tile: WSMapTile) -> [WSUserLocation]? {
        
        do {
            if let storedTile = try mapTileWithQuadKey(tile.quadKey) {
                return storedTile.userLocations
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func clearoutOldTiles() {
        do {
            let tiles = try allMapTiles()
            for tile in tiles {
                if let last_updated = tile.last_updated {
                    if abs(last_updated.timeIntervalSinceNow) > MapTileExpiryTime {
                        print("deleting tile")
                        privateContext.delete(tile)
                    }
                }
            }
        } catch {
            print("Error clearing out old tiles")
        }
    }
    
    func clearoutAllTiles() {
        do {
            let tiles = try allMapTiles()
            for tile in tiles {
                print("deleting tile with quad key \(tile.quad_key)")
                privateContext.delete(tile)
                try savePrivateContext()
            }
        } catch {
            print("Error clearing out map tiles")
        }
    }
    
}
