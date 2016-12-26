//
//  MOMessage.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 31/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData


class MOMessage: NSManagedObject, JSONUpdateable {
    
    // MARK: Getters and setters
    
    var is_new: Bool {
        get { return p_is_new?.boolValue ?? false }
        set(new) { p_is_new = NSNumber(value: new) }
    }
    
    var message_id: Int? {
        get { return p_message_id?.intValue }
        set(new) { p_message_id = new == nil ? nil : NSNumber(value: new!) }
    }
    
    static var entityName: String { return "Message" }
    
    
    // MARK: JSONUpdateable
    
    static func predicate(fromJSON json: Any, withParser parser: JSONParser) throws -> NSPredicate {
        do {
            let message_id = try parser.nonOptional(forKey:"mid", fromJSON: json, withType: Int.self)
            return NSPredicate(format: "p_message_id == %d", Int32(message_id))
        }
    }
    
    func update(withJSON json: Any, withParser parser: JSONParser) throws {
        
        guard let json = json as? [String: Any] else {
            throw MOUpdateError.castingError
        }
        
        do {
            body = parser.optional(forKey: "body", fromJSON: json, withType: String.self)
            is_new = try parser.nonOptional(forKey:"is_new", fromJSON: json, withType: Bool.self)
            message_id = try parser.nonOptional(forKey:"mid", fromJSON: json, withType: Int.self)
            timestamp = try parser.nonOptional(forKey:"timestamp", fromJSON: json, withType: Date.self)
        }
    }

}
