//
//  MKMapView+Warmshowers.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 8/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension MKMapView {
    
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
    
    // Returns the current coordinate limits of a mapview
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
    
    // Returns the current zoom level of the map
    // Zoom levels are as per google maps. 0 = the whole world, 1 = a quadrant of the whole world, ...
    //
    func zoomLevel() -> UInt {
        
        // Zoom levels are calculated as the
        let latitudeZoomLevel = UInt(log2(180.0 / self.region.span.latitudeDelta))
        let longitudeZoomLevel = UInt(log2(360.0 / self.region.span.longitudeDelta))
        return latitudeZoomLevel > longitudeZoomLevel ? latitudeZoomLevel : longitudeZoomLevel
    }
    
}