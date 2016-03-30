//
//  CDWSUserLocation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData
import MapKit

enum CDWSUserLocationError : ErrorType {
    case FailedValueForKey(key: String)
}

class CDWSUserLocation: NSManagedObject {

    // Calculated properties
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude?.doubleValue ?? 0.0, longitude: longitude?.doubleValue ?? 0.0)
    }
    
    var location: CLLocation { return CLLocation(latitude: latitude?.doubleValue ?? 0.0, longitude: longitude?.doubleValue ?? 0.0) }
    
    var distanceToUser: CLLocationDistance? {
        get {
            let lm = CLLocationManager()
            if let location = lm.location {
                return location.distanceFromLocation(self.location)
            }
            return nil
        }
    }

}
