//
//  CDWSMapTile.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData
import MapKit

@objc(CDWSMapTile)
class CDWSMapTile: NSManagedObject {
    
    /** 
     The time at which user location data is deemed to old and should be updated (in seconds).
     Set to 10 minutes.
     */
    let UpdateThresholdTime: Double = 60.0 * 10.0
    
    var userLocations: [WSUserLocation]? {
        
        guard let users = users else {
            return nil
        }
        
        var userLocations = [WSUserLocation]()
        for user in users {
            if user is CDWSUserLocation {
                if let userLocation = WSUserLocation(user: user as! CDWSUserLocation) {
                    userLocations.append(userLocation)
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
        
        guard let last_updated = last_updated else {
            return true
        }
        
        return abs(last_updated.timeIntervalSinceNow) > UpdateThresholdTime
    }
    

}
