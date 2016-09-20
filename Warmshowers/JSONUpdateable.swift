//
//  JSONUpdateable.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

public protocol JSONUpdateable {
    associatedtype UpdateableType: NSFetchRequestResult
    
    /** Returns the entity name. */
    static var entityName: String { get }
    
    /** Returns a predicate from the given JSON that identifies any instances of the type (PSMOType) that exist in the persistance store. */
    static func predicate(fromJSON json: Any) throws -> NSPredicate
    
    /** Updates the reciever with JSON. */
    func update(withJSON json: Any) throws
    
}
