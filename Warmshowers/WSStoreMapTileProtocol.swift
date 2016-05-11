//
//  WSStoreMapTileProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 8/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSStoreMapTileProtocol {
    
    /** Set the map tiel expiry time to 24 hr. */
    var MapTileExpiryTime: NSTimeInterval { get }
    
    /** Returns all the map tiles in the store. */
    func allMapTiles() throws -> [CDWSMapTile]
    
    /** Checks if a map tile is already in the store. */
    func mapTileAtPosition(x: UInt, y: UInt, z: UInt) throws -> CDWSMapTile?
    
    /** Returns a map tile by its identifer.*/
    func mapTileWithID(id: String) throws -> CDWSMapTile?
    
    /** Returns an existing map tile, or a new map tile into the private context. */
    func newOrExistingMapTileAtPosition(x: UInt, y: UInt, z: UInt) throws -> CDWSMapTile
    
    /** Removes tiles from the data base that haven't been loaded in a while. */
    func clearoutOldTiles()
    
    /** Removes all tiles from the store. */
    func clearoutAllTiles()
}