//
//  WSMOUser.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 31/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class WSMOUser: NSManagedObject, JSONUpdateable {

    // MARK: Getters and setters
    
    var distance: Double? {
        get { return p_distance?.doubleValue }
        set(new) { p_distance = new == nil ? nil : NSNumber(double: new!) }
    }
    
    var latitude: Double? {
        get { return p_latitude?.doubleValue }
        set(new) { p_latitude = new == nil ? nil : NSNumber(double: new!) }
    }
    
    var longitude: Double? {
        get { return p_longitude?.doubleValue }
        set(new) { p_longitude = new == nil ? nil : NSNumber(double: new!) }
    }
    
    var not_currently_available: Bool {
        get { return p_not_currently_available?.boolValue ?? false }
        set(new) { p_not_currently_available = NSNumber(bool: new) }
    }
    
    var uid: Int {
        get { return p_uid!.integerValue }
        set(new) { p_uid = NSNumber(integer: new) }
    }

    
    // MARK: Calculated properties
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
    }
    
    var location: CLLocation { return CLLocation(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0) }
    
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
        address.appendWithSpace(post_code)
        if let country = country {
            address.appendWithNewLine(country.uppercaseString)
        }
        return address
    }
    
    
    // MARK: JSONUpdateable
    
    static var entityName: String { return "User" }
    
    static func predicateFromJSON(json: AnyObject) throws -> NSPredicate {
        do {
            let uid = try JSON.nonOptionalForKey("uid", fromDict: json, withType: Int.self)
            return NSPredicate(format: "p_uid == %d", Int32(uid))
        }
    }
    
    func update(json: AnyObject) throws {
        
        guard let json = json as? [String: AnyObject] else {
            throw WSMOUpdateError.CastingError
        }
        
        do {
            fullname = try JSON.nonOptionalForKey("fullname", fromDict: json, withType: String.self)
            name = try JSON.nonOptionalForKey("name", fromDict: json, withType: String.self)
            uid = try JSON.nonOptionalForKey("uid", fromDict: json, withType: Int.self)
        }
    }

}

extension String {
    
    mutating func appendWithCharacter(character: Character, other: String?) {
        
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
    
    mutating func appendWithComma(other: String?) {
        appendWithCharacter(",", other: other)
    }
    
    mutating func appendWithNewLine(other: String?) {
        appendWithCharacter("\n", other: other)
    }
    
    mutating func appendWithSpace(other: String?) {
        appendWithCharacter(" ", other: other)
    }
    
}

