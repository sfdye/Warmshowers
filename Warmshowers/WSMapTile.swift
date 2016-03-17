//
//  WSMapTile.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 8/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSMapTile {
    
    var region: MKCoordinateRegion
    
    init(region: MKCoordinateRegion) {
        self.region = region
    }
    
    init(minimumLatitude: CLLocationDegrees, maximumLatitude: CLLocationDegrees, minimumLongitude: CLLocationDegrees, maximumLongitude: CLLocationDegrees) {
        let centre = CLLocationCoordinate2D(latitude: (minimumLatitude + maximumLatitude) / 2, longitude: (minimumLongitude + maximumLongitude) / 2)
        let span = MKCoordinateSpan(latitudeDelta: abs(maximumLatitude - minimumLatitude), longitudeDelta: abs(maximumLongitude - minimumLongitude))
        let region = MKCoordinateRegion(center: centre, span: span)
        self.region = region
    }
    
    // Initialises a WSMapTile with x, y, z indexes as per google maps tile numbering.
    // e.g. at zoom level 0 (z = 0) there are only 1 x 1 tiles in the world so x = 0, and y = 0
    //      In this case x > 1, y > 1, z = 0 would return nil.
    //
    init?(x: UInt, y: UInt, z: UInt) {
        
        self.region = MKCoordinateRegion()
        
        guard x < UInt(pow(2.0, Double(z))) && y < UInt(pow(2.0, Double(z))) else {
            return nil;
        }
        
        let span = MKCoordinateSpan(
            latitudeDelta: Double(180 / pow(2.0,Double(z))),
            longitudeDelta: Double(360 / pow(2.0,Double(z)))
        )
        
        let centre = CLLocationCoordinate2D(
            latitude: span.latitudeDelta * (Double(y) + 0.5),
            longitude: span.longitudeDelta * (Double(x) + 0.5)
        )
        
        self.region = MKCoordinateRegion(center: centre, span: span)
    }
    
    var minimumLatitude: Double {
        return self.region.center.latitude - self.region.span.latitudeDelta / 2.0
    }
    
    var maximumLatitude: Double {
        return self.region.center.latitude + self.region.span.latitudeDelta / 2.0
    }
    
    var minimumLongitude: Double {
        return self.region.center.longitude - self.region.span.longitudeDelta / 2.0
    }
    
    var maximumLongitude: Double {
        return self.region.center.longitude + self.region.span.longitudeDelta / 2.0
    }
    
    // Returns the coordinate limits of a map tile
    // Used for getting hosts in the current displayed region in getHostDataForMapView
    //
    func getWSMapRegion(limit: Int = 100) -> [String: String] {
        
        let region = self.region
        
        let regionLimits: [String: String] = [
            "minlat": String(self.minimumLatitude),
            "maxlat": String(self.maximumLatitude),
            "minlon": String(self.minimumLongitude),
            "maxlon": String(self.maximumLongitude),
            "centerlat": String(region.center.latitude),
            "centerlon": String(region.center.longitude)
        ]
        
        return regionLimits
    }
    
}
