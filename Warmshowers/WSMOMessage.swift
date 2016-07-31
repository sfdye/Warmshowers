//
//  WSMOMessage.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 31/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData


class WSMOMessage: NSManagedObject, JSONUpdateable {

    // MARK: Getters and setters
    
    var is_new: Bool {
        get { return p_is_new?.boolValue ?? false }
        set(new) { p_is_new = NSNumber(bool: new) }
    }
    
    var message_id: Int? {
        get { return p_message_id?.integerValue }
        set(new) { p_message_id = new == nil ? nil : NSNumber(integer: new!) }
    }
    
    
    // MARK: JSONUpdateable
    
    static var entityName: String { return "Message" }
    
    static func predicateFromJSON(json: AnyObject) throws -> NSPredicate {
        do {
            let message_id = try JSON.nonOptionalForKey("mid", fromDict: json, withType: Int.self)
            return NSPredicate(format: "p_message_id == %d", Int32(message_id))
        }
    }
    
    func update(json: AnyObject) throws {
        
        guard let json = json as? [String: AnyObject] else {
            throw WSMOUpdateError.CastingError
        }
        
        do {
            body = JSON.optionalForKey("body", fromDict: json, withType: String.self)
            is_new = try JSON.nonOptionalForKey("is_new", fromDict: json, withType: Bool.self)
            message_id = try JSON.nonOptionalForKey("mid", fromDict: json, withType: Int.self)
            timestamp = try JSON.nonOptionalForKey("timestamp", fromDict: json, withType: NSDate.self)
        }
    }

}
