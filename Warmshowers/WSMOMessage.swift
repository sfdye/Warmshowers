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
    typealias UpdateableType = WSMOMessage
    
    // MARK: Getters and setters
    
    var is_new: Bool {
        get { return p_is_new?.boolValue ?? false }
        set(new) { p_is_new = NSNumber(value: new) }
    }
    
    var message_id: Int? {
        get { return p_message_id?.intValue }
        set(new) { p_message_id = new == nil ? nil : NSNumber(value: new!) }
    }
    
    
    // MARK: JSONUpdateable
    
    static var entityName: String { return "Message" }
    
    static func predicate(fromJSON json: Any) throws -> NSPredicate {
        do {
            let message_id = try JSON.nonOptional(forKey:"mid", fromJSON: json, withType: Int.self)
            return NSPredicate(format: "p_message_id == %d", Int32(message_id!))
        }
    }
    
//    static func fetchRequest() -> NSFetchRequest<UpdateableType> {
//        let request = NSFetchRequest<UpdateableType>(entityName: entityName)
//        return request
//    }
    
    func update(withJSON json: Any) throws {
        
        guard let json = json as? [String: Any] else {
            throw WSMOUpdateError.castingError
        }
        
        do {
            body = JSON.optional(forKey: "body", fromJSON: json, withType: String.self)
            is_new = try JSON.nonOptional(forKey:"is_new", fromJSON: json, withType: Bool.self)
            message_id = try JSON.nonOptional(forKey:"mid", fromJSON: json, withType: Int.self)
            timestamp = try JSON.nonOptional(forKey:"timestamp", fromJSON: json, withType: Date.self)
        }
    }

}
