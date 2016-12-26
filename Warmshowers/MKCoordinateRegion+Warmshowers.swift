//
//  MKCoordinateRegion+Warmshowers.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 25/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import MapKit

extension MKCoordinateRegion {
    
    var minimumLatitude: Double {
        return center.latitude - span.latitudeDelta / 2.0
    }
    
    var maximumLatitude: Double {
        return center.latitude + span.latitudeDelta / 2.0
    }
    
    var minimumLongitude: Double {
        return center.longitude - span.longitudeDelta / 2.0
    }
    
    var maximumLongitude: Double {
        return center.longitude + span.longitudeDelta / 2.0
    }
    
}
