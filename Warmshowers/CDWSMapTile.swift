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
     * The time at which user location data is deemed to old and should be updated (in seconds)
     * Set to 10 minutes
     */
    let UpdateThresholdTime: Double = 60.0 * 10.0
    
    // MARK: Identifier property
    
    var identifierFromXYZ: String {
        return String(x!) + String(y!) + String(z!)
    }
    
    // MARK: Map tile region properties
    
    var latitudeDelta: CLLocationDegrees {
        return 180 / pow(2.0, Double(z!))
    }
    
    var longitudeDelta: CLLocationDegrees {
        return 360 / pow(2.0, Double(z!))
    }
    
    var minimumLatitude: CLLocationDegrees {
        return (-y!.doubleValue * latitudeDelta) + 90
    }
    
    var maximumLatitude: CLLocationDegrees { 
        return (-(y!.doubleValue + 1) * latitudeDelta) + 90
    }
    
    var minimumLongitude: CLLocationDegrees {
        return (x!.doubleValue * longitudeDelta) - 180
    }
    
    var maximumLongitude: CLLocationDegrees {
        return ((x!.doubleValue + 1) * longitudeDelta) - 180
    }
    
    var latitudeCentre: CLLocationDegrees {
        return minimumLatitude + latitudeDelta / 2.0
    }
    
    var longitudeCentre: CLLocationDegrees {
        return minimumLongitude + longitudeDelta / 2.0
    }
    
    var region: MKCoordinateRegion {
        let centre = CLLocationCoordinate2D(latitude: latitudeCentre, longitude: longitudeCentre)
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let region = MKCoordinateRegion(center: centre, span: span)
        return region
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
    
    /**
     * Returns the coordinate limits of a map tile. 
     * Used for getting hosts in the current displayed region in getHostDataForMapView
     */
    func getWSMapRegionLimits() -> [String: String] {
        
        let regionLimits: [String: String] = [
            "minlat": String(latitudeCentre - latitudeDelta / 2.0),
            "maxlat": String(latitudeCentre + latitudeDelta / 2.0),
            "minlon": String(longitudeCentre - longitudeDelta / 2.0),
            "maxlon": String(longitudeCentre + longitudeDelta / 2.0),
            "centerlat": String(latitudeCentre),
            "centerlon": String(longitudeCentre)
        ]
        
        return regionLimits
    }
    
    /**
     * Returns a polygon that overlays the tile
     */
    func polygon() -> MKPolygon {
        var vertices = [CLLocationCoordinate2D]()
        vertices.append(CLLocationCoordinate2D(latitude: maximumLatitude, longitude: minimumLongitude))
        vertices.append(CLLocationCoordinate2D(latitude: maximumLatitude, longitude: maximumLongitude))
        vertices.append(CLLocationCoordinate2D(latitude: minimumLatitude, longitude: maximumLongitude))
        vertices.append(CLLocationCoordinate2D(latitude: minimumLatitude, longitude: minimumLongitude))
        let box = MKPolygon(coordinates: &vertices, count: 4)
        return box
    }

}
