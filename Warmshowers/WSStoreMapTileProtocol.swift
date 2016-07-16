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
    
    /** Returns a map tile by its identifer.*/
    func mapTileWithQuadKey(quadKey: String) throws -> CDWSMapTile?
    
    /** Returns an existing map tile, or a new map tile into the private context. */
    func newOrExistingMapTileWithQuadKey(quadKey: String) throws -> CDWSMapTile
    
    /** Returns true if the store has recently refreshed host data for the area covered by the given map tile. */
    func hasValidHostDataForMapTile(tile: WSMapTile) -> Bool
    
    /** Returns users on a given map tile from the store. */
    func usersForMapTile(tile: WSMapTile) -> [WSUserLocation]
    
    /** Removes tiles from the data base that haven't been loaded in a while. */
    func clearoutOldTiles()
    
    /** Removes all tiles from the store. */
    func clearoutAllTiles()
}