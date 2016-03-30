//
//  WSStore+MapTile.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

extension WSStore {
    
    // MARK: Map Tile handling methods
    
    // Returns all the map tiles in the store
    //
    class func allMapTiles() throws -> [CDWSMapTile] {
        
        do {
            let tiles = try getAllFromEntity(.MapTile) as! [CDWSMapTile]
            return tiles
        }
    }
    
    // Checks if a map tile is already in the store.
    //
    class func mapTileAtPosition(x: UInt, y: UInt, z: UInt) throws -> CDWSMapTile? {
        
        let request = requestForEntity(.MapTile)
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "x == %i", x))
        predicates.append(NSPredicate(format: "y == %i", y))
        predicates.append(NSPredicate(format: "z == %i", z))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        do {
            let tile = try executeFetchRequest(request).first as? CDWSMapTile
            return tile
        }
    }
    
    // Returns a map tile by its identifer.
    class func mapTileWithID(id: String) throws -> CDWSMapTile? {
        
        let request = requestForEntity(.MapTile)
        request.predicate = NSPredicate(format: "%K == %@", "identifier", id)
        
        do {
            let tile = try executeFetchRequest(request).first as? CDWSMapTile
            return tile
        }
    }
    
    // Returns an existing map tile, or a new map tile into the private context.
    //
    class func newOrExistingMapTileAtPosition(x: UInt, y: UInt, z: UInt) throws -> CDWSMapTile {
        do {
            if let tile = try mapTileAtPosition(x, y: y, z: z) {
                return tile
            } else {
                let tile = NSEntityDescription.insertNewObjectForEntityForName(WSEntity.MapTile.rawValue, inManagedObjectContext: sharedStore.privateContext) as! CDWSMapTile
                tile.x = x
                tile.y = y
                tile.z = z
                tile.identifier = tile.identifierFromXYZ
                return tile
            }
        }
    }
    
    // Removes tiles from the data base that haven't been loaded in a while.
    class func clearoutOldTiles() {
        do {
            let tiles = try allMapTiles()
            for tile in tiles {
                if let last_updated = tile.last_updated {
                    if abs(last_updated.timeIntervalSinceNow) > MapTileExpiryTime {
                        print("deleting tile")
                        sharedStore.privateContext.deleteObject(tile)
                    }
                }
            }
        } catch {
            print("Error clearing out old tiles")
        }
    }
    
    // Removes all tiles from the store.
    class func clearoutAllTiles() {
        do {
            let tiles = try WSStore.allMapTiles()
            for tile in tiles {
                print("deleting tile with id \(tile.identifier)")
                sharedStore.privateContext.deleteObject(tile)
                try savePrivateContext()
            }
        } catch {
            print("Error clearing out map tiles")
        }
    }
    
}