//
//  WSMOMapTile.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 31/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

@objc(WSMOMapTile)
class WSMOMapTile: NSManagedObject, JSONUpdateable {

    // MARK: JSONUpdateable
    
    static var entityName: String { return "MapTile" }
    
    static func predicateFromJSON(json: AnyObject) throws -> NSPredicate {
        do {
            let quad_key = try JSON.nonOptionalForKey("quad_key", fromDict: json, withType: String.self)
            return NSPredicate(format: "quad_key == %@", quad_key)
        }
    }
    
    func update(json: AnyObject) throws { }
    
    
    /**
     The time (in seconds) at which cached user location data is deemed to old and should be updated by downloading fresh data from the the warmshowers website.
     Set to 1 hour.
     */
    let UpdateThresholdTime: Double = 60.0 * 60.0
    
    var userLocations: Set<WSUserLocation>? {
        guard let users = users else { return nil }
        
        var userLocations = Set<WSUserLocation>()
        for user in users {
            if user is WSMOUser {
                if let userLocation = WSUserLocation(user: user as! WSMOUser) {
                    userLocations.insert(userLocation)
                }
            }
        }
        return userLocations
    }
    
    // MARK: Utility methods
    
    /**
     * Returns true if the map tile data has not been updated recently
     */
    func needsUpdating() -> Bool {
        
        // Return true if it's not know when the tile was last updated. i.e. the tile has never been updated.
        guard let last_updated = last_updated else { return true }
        
        return abs(last_updated.timeIntervalSinceNow) > UpdateThresholdTime
    }

}
