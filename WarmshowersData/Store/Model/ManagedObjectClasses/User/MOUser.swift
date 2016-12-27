//
//  MOUser.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 31/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData
import MapKit

public class MOUser: NSManagedObject, JSONUpdateable {
    
    // MARK: Getters and setters
    
    public var distance: Double? {
        get { return p_distance?.doubleValue }
        set(new) { p_distance = new == nil ? nil : NSNumber(value: new! as Double) }
    }
    
    public var latitude: Double? {
        get { return p_latitude?.doubleValue }
        set(new) { p_latitude = new == nil ? nil : NSNumber(value: new! as Double) }
    }
    
    public var longitude: Double? {
        get { return p_longitude?.doubleValue }
        set(new) { p_longitude = new == nil ? nil : NSNumber(value: new! as Double) }
    }
    
    public var not_currently_available: Bool? {
        get { return p_not_currently_available?.boolValue ?? true }
        set(new) { p_not_currently_available = new == nil ? nil : NSNumber(value: new! as Bool) }
    }
    
    public var uid: Int {
        get { return p_uid!.intValue }
        set(new) { p_uid = NSNumber(value: new as Int) }
    }

    
    // MARK: Calculated properties
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
    }
    
    public var location: CLLocation { return CLLocation(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0) }
    
    public var distanceToUser: CLLocationDistance? {
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
    
    public var address: String {
        var address: String = ""
        address.appendWithNewLine(street)
        address.appendWithNewLine(additional)
        address.appendWithNewLine(city)
        address.appendWithSpace(post_code)
        if let country = country {
            address.appendWithNewLine(country.uppercased())
        }
        return address
    }
    
    // MARK: JSONUpdateable
    
    static func predicate(fromJSON json: Any, withParser parser: JSONParser) throws -> NSPredicate {
        do {
            let uid = try parser.nonOptional(forKey:"uid", fromJSON: json, withType: Int.self)
            return NSPredicate(format: "p_uid == %d", Int32(uid))
        }
    }
    
    func update(withJSON json: Any, withParser parser: JSONParser) throws {
        
        guard let json = json as? [String: Any] else {
            throw MOUpdateError.castingError
        }
        
        do {
            fullname = try parser.nonOptional(forKey:"fullname", fromJSON: json, withType: String.self)
            name = try parser.nonOptional(forKey:"name", fromJSON: json, withType: String.self)
            uid = try parser.nonOptional(forKey:"uid", fromJSON: json, withType: Int.self)
            // Non essential properties.
            additional = parser.optional(forKey: "additional", fromJSON: json, withType: String.self)
            city = parser.optional(forKey: "city", fromJSON: json, withType: String.self)
            country = parser.optional(forKey: "country", fromJSON: json, withType: String.self)
            distance = parser.optional(forKey: "distance", fromJSON: json, withType: Double.self)
            image_url = parser.optional(forKey: "profile_image_map_infoWindow", fromJSON: json, withType: String.self)
            latitude = parser.optional(forKey: "latitude", fromJSON: json, withType: Double.self)
            longitude = parser.optional(forKey: "longitude", fromJSON: json, withType: Double.self)
            not_currently_available = parser.optional(forKey: "notcurrentlyavailable", fromJSON: json, withType: Bool.self)
            post_code = parser.optional(forKey: "post_code", fromJSON: json, withType: String.self)
            province = parser.optional(forKey: "province", fromJSON: json, withType: String.self)
            street = parser.optional(forKey: "street", fromJSON: json, withType: String.self)
        }
    }

}

extension String {
    
    mutating func appendWithCharacter(_ character: Character, other: String?) {
        
        guard let other = other else {
            return
        }
        
        if self == "" {
            self += other
        } else {
            self += String(character)
            if character != "\n" {
                self += " "
            }
            self += other
        }
    }
    
    mutating func appendWithComma(_ other: String?) {
        appendWithCharacter(",", other: other)
    }
    
    mutating func appendWithNewLine(_ other: String?) {
        appendWithCharacter("\n", other: other)
    }
    
    mutating func appendWithSpace(_ other: String?) {
        appendWithCharacter(" ", other: other)
    }
    
}

