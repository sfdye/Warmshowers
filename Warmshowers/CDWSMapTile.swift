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
     The time (in seconds) at which cached user location data is deemed to old and should be updated by downloading fresh data from the the warmshowers website.
     Set to 1 hour.
     */
    let UpdateThresholdTime: Double = 60.0 * 60.0
    
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
        guard let last_updated = last_updated else { return true }
        return abs(last_updated.timeIntervalSinceNow) > UpdateThresholdTime
    }
    

}
