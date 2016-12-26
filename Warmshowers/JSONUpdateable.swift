//
//  JSONUpdateable.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

protocol JSONUpdateable {
    
    /** Returns a predicate from the given JSON that identifies any instances of the type (PSMOType) that exist in the persistance store. */
    static func predicate(fromJSON json: Any) throws -> NSPredicate
    
    /** Updates the reciever with JSON. */
    func update(withJSON json: Any) throws
    
}
