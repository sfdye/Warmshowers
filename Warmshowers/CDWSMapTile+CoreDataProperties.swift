//
//  CDWSMapTile+CoreDataProperties.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDWSMapTile {

    @NSManaged var identifier: String?
    @NSManaged var last_updated: NSDate?
    @NSManaged var x: NSNumber?
    @NSManaged var y: NSNumber?
    @NSManaged var z: NSNumber?
    @NSManaged var users: NSSet?

}
