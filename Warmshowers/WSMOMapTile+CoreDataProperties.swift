//
//  WSMOMapTile+CoreDataProperties.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 5/08/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WSMOMapTile {

    @NSManaged var last_updated: Date?
    @NSManaged var quad_key: String?
    @NSManaged var parent_tile: WSMOMapTile?
    @NSManaged var sub_tiles: NSSet?
    @NSManaged var users: NSSet?

}
