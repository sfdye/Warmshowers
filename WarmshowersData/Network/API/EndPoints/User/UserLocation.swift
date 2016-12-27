//
//  UserLocation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 26/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

enum UserLocationError: Error {
    case invalidInput
}

public class UserLocation: NSObject {
    
    // MARK: Properties
    
    public var fullname: String
    var name: String
    public var uid: Int
    var additional: String?
    var city: String?
    var country: String?
    var distance: Double?
    var latitude: Double { return coordinate.latitude }
    var longitude: Double { return coordinate.longitude }
    public var coordinate: CLLocationCoordinate2D
    public var notcurrentlyavailable: Bool?
    var postCode: String?
    var province: String?
    public var imageURL: String?
    var street: String? = nil
    public var image: UIImage?
    var tileID: String?
    
    
    // MARK: Calculated Properties
    
    override public var hashValue: Int { return uid }
    
    var location: CLLocation { return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude) }
    
    var distanceToUser: CLLocationDistance? {
        get {
            let lm = CLLocationManager()
            if let location = lm.location {
                return location.distance(from: self.location)
            }
            return nil
        }
    }
    
    public var shortAddress: String {
        var address: String = ""
        address.appendWithComma(city)
        if let country = country {
            address.appendWithComma(country.uppercased())
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
            address.appendWithNewLine(country.uppercased())
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
    
    init?(user: MOUser) {
        
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
    
    // Initialises a UserLocation instance with json data.
    convenience init?(json: AnyObject) {
        
        self.init(fullname: "", name: "", uid: 0, lat: 0.0, lon: 0.0)
        
        // At a minimum, the object must have a uid, latitude and longitude
        guard let fullname = json.value(forKey: "fullname") as? String,
              let name = json.value(forKey: "name") as? String,
              let uid = (json.value(forKey: "uid") as AnyObject).integerValue,
              let lat = (json.value(forKey: "latitude") as AnyObject).doubleValue,
              let lon = (json.value(forKey: "longitude") as AnyObject).doubleValue
            else {
                return nil
        }
        
        self.fullname = fullname
        self.name = name
        self.uid = uid
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        if let data = json as? NSDictionary {
            additional = data.value(forKey: "additional") as? String
            city = data.value(forKey: "city") as? String
            country = data.value(forKey: "country") as? String
            distance = (data.value(forKey: "distance") as AnyObject).doubleValue
            notcurrentlyavailable = (json.value(forKey: "notcurrentlyavailable") as AnyObject).boolValue
            postCode = data.value(forKey: "postal_code") as? String
            province = json.value(forKey: "province") as? String
            imageURL = json.value(forKey: "profile_image_map_infoWindow") as? String
            street = json.value(forKey: "street") as? String
        }
    }
    
}

func ==(lhs: UserLocation, rhs: UserLocation) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
