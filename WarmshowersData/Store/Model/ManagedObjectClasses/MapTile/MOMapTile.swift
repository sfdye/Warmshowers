//
//  MOMapTile.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 31/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

@objc(MOMapTile)
class MOMapTile: NSManagedObject, JSONUpdateable {

    static var entityName: String { return "MapTile" }
    
    
    // MARK: JSONUpdateable
    
    static func predicate(fromJSON json: Any, withParser parser: JSONParser) throws -> NSPredicate {
        do {
            let quad_key = try parser.nonOptional(forKey:"quad_key", fromJSON: json, withType: String.self)
            return NSPredicate(format: "quad_key == %@", quad_key)
        }
    }
    
    func update(withJSON json: Any, withParser parser: JSONParser) throws { }
    
    
    /**
     The time (in seconds) at which cached user location data is deemed to old and should be updated by downloading fresh data from the the warmshowers website.
     Set to 24 hours.
     */
    let UpdateThresholdTime: Double = 24.0 * 60.0 * 60.0
    
//    var userLocations: Set<UserLocation>? {
//        guard let users = users else { return nil }
//        
//        var userLocations = Set<UserLocation>()
//        for user in users {
//            if user is MOUser {
//                if let userLocation = UserLocation(user: user as! MOUser) {
//                    userLocations.insert(userLocation)
//                }
//            }
//        }
//        return userLocations
//    }
    
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
