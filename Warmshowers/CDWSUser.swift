//
//  CDWSUser.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 4/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData
import MapKit

enum CDWSUserError : ErrorProtocol {
    case failedValueForKey(key: String)
}

class CDWSUser: NSManagedObject {
    
//    , WSLazyImage
//    // MARK: WSLazyImage Protocol
//    
//    var lazyImageURL: String? {
//        get {
//            return image_url
//        }
//    }
//    
//    var lazyImage: UIImage? {
//        get {
//            return image as? UIImage
//        }
//        set(newImage) {
//            image = newImage
//        }
//    }
    
    // Calculated properties
    
    var shortAddress: String {
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
        address.appendWithSpace(post_code)
        if let country = country {
            address.appendWithNewLine(country.uppercased())
        }
        return address
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
