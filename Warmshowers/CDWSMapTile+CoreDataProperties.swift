//
//  CDWSMapTile+CoreDataProperties.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 6/06/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDWSMapTile {

    @NSManaged var last_updated: Date?
    @NSManaged var quad_key: String?
    @NSManaged var users: NSSet?

}
