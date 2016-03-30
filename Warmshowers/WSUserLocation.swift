//
//  WSUserLocation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 26/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit
import Contacts

enum WSUserLocationError: ErrorType {
    case InvalidInput
}

class WSUserLocation : WSUser {
    
    // MARK - Properties
    
    var additional: String?
    var city: String?
    var country: String?
    var distance: Double?
//    var latitude: Double?
//    var longitude: Double?
    var coordinate: CLLocationCoordinate2D
    var notcurrentlyavailable: Bool?
    var postCode: String?
    var province: String?
    var thumbnailImageURL: String?
    var street: String? = nil
    var thumbnailImage: UIImage?
    var tileID: String?
    
    // MARK - Calculated Properties
    
    var location: CLLocation { return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude) }
    
    var distanceToUser: CLLocationDistance? {
        get {
            let lm = CLLocationManager()
            if let location = lm.location {
                return location.distanceFromLocation(self.location)
            }
            return nil
        }
    }
    
    var shortAddress: String {
        var address: String = ""
        address.appendWithComma(city)
        if let country = country {
            address.appendWithComma(country.uppercaseString)
        }
        return address
    }
    
    var address: String {
        var address: String = ""
        address.appendWithNewLine(street)
        address.appendWithNewLine(additional)
        address.appendWithNewLine(city)
        address.appendWithSpace(postCode)
        if let country = country {
            address.appendWithNewLine(country.uppercaseString)
        }
        return address
    }
    
    // MARK - Initializers
    
    init(fullname: String, name: String, uid: Int, lat: Double, lon: Double) {
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        super.init(fullname: fullname, name: name, uid: uid)
    }
    
    // initialises a WSUserLocation instance with json data
    convenience init?(json: AnyObject) {
        
        self.init(fullname: "", name: "", uid: 0, lat: 0.0, lon: 0.0)
        
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
            additional = data.valueForKey("additional") as? String
            city = data.valueForKey("city") as? String
            country = data.valueForKey("country") as? String
            distance = data.valueForKey("distance")?.doubleValue
            notcurrentlyavailable = json.valueForKey("notcurrentlyavailable")?.boolValue
            postCode = data.valueForKey("postal_code") as? String
            province = json.valueForKey("province") as? String
            thumbnailImageURL = json.valueForKey("profile_image_map_infoWindow") as? String
            street = json.valueForKey("street") as? String
        }
    }
    
    convenience init?(user: CDWSUserLocation, tileID: String) {
        
        self.init(fullname: "", name: "", uid: 0, lat: 0.0, lon: 0.0)
        
        // At a minimum, the object must have a uid, latitude and longitude
        guard let fullname = user.fullname,
            let name = user.name,
            let uid = user.uid?.integerValue,
            let lat = user.latitude?.doubleValue,
            let lon = user.longitude?.doubleValue
            else {
                return nil
        }
        
        self.fullname = fullname
        self.name = name
        self.uid = uid
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.thumbnailImage = user.image as? UIImage
        self.thumbnailImageURL = user.image_url
    }
    
}