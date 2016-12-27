//
//  MOMapTile+CoreDataProperties.swift
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

extension MOMapTile {

    @NSManaged public var last_updated: Date?
    @NSManaged public var quad_key: String?
    @NSManaged public var parent_tile: MOMapTile?
    @NSManaged public var sub_tiles: NSSet?
    @NSManaged public var users: NSSet?

}
