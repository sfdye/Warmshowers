//
//  CDWSUser.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 4/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

enum CDWSUserError : ErrorType {
    case FailedValueForKey(key: String)
}

class CDWSUser: NSManagedObject, WSLazyImage {
    
    // MARK: WSLazyImage Protocol
    
    var lazyImageURL: String? {
        get {
            return image_url
        }
    }
    
    var lazyImage: UIImage? {
        get {
            return image as? UIImage
        }
        set(newImage) {
            image = newImage
        }
    }
    
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
