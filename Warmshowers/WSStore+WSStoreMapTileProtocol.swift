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
    
    var MapTileExpiryTime: NSTimeInterval { return 60.0 * 60.0 * 24.0 }
    
    func allMapTiles() throws -> [CDWSMapTile] {
        
        do {
            let tiles = try getAllEntriesFromEntity(.MapTile) as! [CDWSMapTile]
            return tiles
        }
    }
    
    func mapTileAtPosition(x: UInt, y: UInt, z: UInt) throws -> CDWSMapTile? {
        
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
    
    func mapTileWithID(id: String) throws -> CDWSMapTile? {
        
        let request = requestForEntity(.MapTile)
        request.predicate = NSPredicate(format: "%K == %@", "identifier", id)
        
        do {
            let tile = try executeFetchRequest(request).first as? CDWSMapTile
            return tile
        }
    }
    
    func newOrExistingMapTileAtPosition(x: UInt, y: UInt, z: UInt) throws -> CDWSMapTile {
        do {
            if let tile = try mapTileAtPosition(x, y: y, z: z) {
                return tile
            } else {
                let tile = NSEntityDescription.insertNewObjectForEntityForName(WSEntity.MapTile.rawValue, inManagedObjectContext: privateContext) as! CDWSMapTile
                tile.x = x
                tile.y = y
                tile.z = z
                tile.identifier = tile.identifierFromXYZ
                return tile
            }
        }
    }
    
    func hasValidHostDataForMapTile(tile: WSMapTile) -> Bool {
        
        print("no users")
        return false
    }
    
    func usersForMapTile(tile: WSMapTile) -> [WSUserLocation]? {
        
        return nil
    }
    
    func clearoutOldTiles() {
        do {
            let tiles = try allMapTiles()
            for tile in tiles {
                if let last_updated = tile.last_updated {
                    if abs(last_updated.timeIntervalSinceNow) > MapTileExpiryTime {
                        print("deleting tile")
                        privateContext.deleteObject(tile)
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
                print("deleting tile with id \(tile.identifier)")
                privateContext.deleteObject(tile)
                try savePrivateContext()
            }
        } catch {
            print("Error clearing out map tiles")
        }
    }
    
}