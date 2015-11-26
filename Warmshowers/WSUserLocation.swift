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
    var uid: Int? = nil
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    // initialises a WSUserLocation instance with json data
    class func initWithObject(userData: AnyObject) -> WSUserLocation? {
        
        let lat = userData.valueForKey("latitude")?.doubleValue
        let lon = userData.valueForKey("longitude")?.doubleValue
        if lat == nil || lon == nil {
            return nil
        }
        
        let user = WSUserLocation.init(coordinate: CLLocationCoordinate2D.init(latitude: lat!, longitude: lon!))
        
        user.uid = userData.valueForKey("uid")?.integerValue
        
        // At a minimum, the object must have a uid, latitude and longitude
        if user.uid == nil {
            print("here")
            return nil
        }
        
        user.city = userData.valueForKey("city")?.stringValue
        user.country = userData.valueForKey("country")?.stringValue
        user.distance = userData.valueForKey("distance")?.doubleValue
        user.fullname = userData.valueForKey("fullname")?.stringValue
        user.name = userData.valueForKey("name")?.stringValue
        user.notcurrentlyavailable = userData.valueForKey("notcurrentlyavailable")?.boolValue
        user.province = userData.valueForKey("province")?.stringValue
        user.profile_image_map_infoWindow = userData.valueForKey("profile_image_map_infoWindow")?.stringValue
        user.street = userData.valueForKey("street")?.stringValue
        
        return user

    }
    
    
    // MARK: - MKAnnotation protocol methods
    
    var title: String? {
        return self.fullname
    }
    
    var subtitle: String? {
        
        var subtitle: String? = ""
        
        if self.city != nil {
            subtitle! += self.city!
        }
        
        if self.country != nil {
            if subtitle != "" {
                subtitle! += ", \(self.country!)"
            } else {
                subtitle! += self.country!
            }
        }
        
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