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

class WSUserLocation : WSUser, MKAnnotation {
    
    var city: String? = nil
    var country: String? = nil
    var distance: Double? = nil
    var coordinate: CLLocationCoordinate2D
    var notcurrentlyavailable: Bool? = nil
    var province: String? = nil
    var profile_image_map_infoWindow: String? = nil
    var street: String? = nil
    
    init(fullname: String, name: String, uid: Int, lat: Double, lon: Double) {
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        super.init(fullname: fullname, name: name, uid: uid)
    }
    
    init(user: WSUser, location: CLLocationCoordinate2D) {
        self.coordinate = location
        super.init(fullname: user.fullname, name: user.name, uid: user.uid)
    }
    
    // initialises a WSUserLocation instance with json data
    init?(json: AnyObject) {
        
        self.coordinate = CLLocationCoordinate2D()
        super.init(fullname: "", name: "", uid: 0)
        
        // At a minimum, the object must have a uid, latitude and longitude
        guard let fullname = json.valueForKey("fullname") as? String,
              let name = json.valueForKey("name") as? String,
              let uid = json.valueForKey("uid")?.integerValue,
              let lat = json.valueForKey("latitude")?.doubleValue,
              let lon = json.valueForKey("longitude")?.doubleValue
            else {
                return nil
        }
        
        self.fullname = fullname
        self.name = name
        self.uid = uid
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        if let data = json as? NSDictionary {
            city = data.valueForKey("city") as? String
            country = data.valueForKey("country") as? String
            distance = data.valueForKey("distance")?.doubleValue
            notcurrentlyavailable = json.valueForKey("notcurrentlyavailable")?.boolValue
            province = json.valueForKey("province") as? String
            profile_image_map_infoWindow = json.valueForKey("profile_image_map_infoWindow") as? String
            street = json.valueForKey("street") as? String
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