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

class WSUserLocation: NSObject {
    
    // MARK: Properties
    
    var fullname: String
    var name: String
    var uid: Int
    var additional: String?
    var city: String?
    var country: String?
    var distance: Double?
    var latitude: Double { return coordinate.latitude }
    var longitude: Double { return coordinate.longitude }
    var coordinate: CLLocationCoordinate2D
    var notcurrentlyavailable: Bool?
    var postCode: String?
    var province: String?
    var imageURL: String?
    var street: String? = nil
    var image: UIImage?
    var tileID: String?
    
    
    // MARK: Calculated Properties
    
    override var hashValue: Int { return uid }
    
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
    
    // MARK: Initializers
    
    init(fullname: String, name: String, uid: Int, lat: Double, lon: Double) {
        self.fullname = fullname
        self.name = name
        self.uid = uid
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    init?(user: WSMOUser) {
        
        // At a minimum, the object must have a uid, latitude and longitude
        guard
            let fullname = user.fullname,
            let name = user.name,
            let lat = user.latitude,
            let lon = user.longitude
            else {
                return nil
        }
        
        self.fullname = fullname
        self.name = name
        self.uid = user.uid
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.image = user.image as? UIImage
        self.imageURL = user.image_url
        self.tileID = user.map_tile?.quad_key
    }
    
    // Initialises a WSUserLocation instance with json data.
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
            imageURL = json.valueForKey("profile_image_map_infoWindow") as? String
            street = json.valueForKey("street") as? String
        }
    }
    
}

func ==(lhs: WSUserLocation, rhs: WSUserLocation) -> Bool {
    return lhs.hashValue == rhs.hashValue
}