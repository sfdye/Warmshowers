//
//  WSUserLocation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 26/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation
import MapKit
import Contacts

enum WSUserLocationError: ErrorType {
    case InvalidInput
}

class WSUserLocation : NSObject, MKAnnotation {
    
    var city: String? = nil
    var country: String? = nil
    var distance: Double? = nil
    var fullname: String? = nil
    var coordinate: CLLocationCoordinate2D
    var name: String? = nil
    var notcurrentlyavailable: Bool? = nil
    var province: String? = nil
    var profile_image_map_infoWindow: String? = nil
    var street: String? = nil
    var uid: Int
    
    override init() {
        coordinate = CLLocationCoordinate2D()
        uid = 0
    }
    
    // initialises a WSUserLocation instance with json data
    convenience init?(userData: AnyObject) {
        self.init()
        
        // At a minimum, the object must have a uid, latitude and longitude
        guard let lat = userData.valueForKey("latitude")?.doubleValue,
            let lon = userData.valueForKey("longitude")?.doubleValue,
            let uid = userData.valueForKey("uid")?.integerValue
            else {
                return nil
        }
        
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.uid = uid
        
        if let data = userData as? NSDictionary {
            city = data.valueForKey("city") as? String
            country = data.valueForKey("country") as? String
            distance = data.valueForKey("distance")?.doubleValue
            fullname = data.valueForKey("fullname") as? String
            name = data.valueForKey("name") as? String
            notcurrentlyavailable = userData.valueForKey("notcurrentlyavailable")?.boolValue
            province = userData.valueForKey("province") as? String
            profile_image_map_infoWindow = userData.valueForKey("profile_image_map_infoWindow") as? String
            street = userData.valueForKey("street") as? String
        }
        
    }
    
    
    // MARK: - MKAnnotation protocol methods
    
    var title: String? {
        return fullname
    }
    
    var subtitle: String? {
        
        var subtitle: String? = ""
            
        if distance != nil {
            subtitle! += String(format: "within %.0f metres", arguments: [distance!])
//            if (city != nil) || (country != nil) {
//                subtitle! += " at "
//            }
        }

//        if city != nil {
//            subtitle! += city!
//        }
//        
//        if country != nil {
//            if subtitle != "" {
//                subtitle! += ", \(country!)"
//            } else {
//                subtitle! += country!
//            }
//        }
        
        return subtitle
 
    }
    
//    // annotation callout info button opens this mapItem in Maps app
//    func mapItem() -> MKMapItem {
//        let addressDictionary = [String(CNPostalAddressStreetKey): self.subtitle!]
//        // make a MKPlacemark object with the location coordinates
//        let placemark = MKPlacemark(coordinate: coordinate!, addressDictionary: addressDictionary)
//        // convert to a MKMapItem
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = title
//        return mapItem
//    }
    
}