//
//  MOUser+CoreDataProperties.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 31/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MOUser {

    @NSManaged public var additional: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged var p_distance: NSNumber?
    @NSManaged public var fullname: String?
    @NSManaged public var image: NSObject?
    @NSManaged public var image_url: String?
    @NSManaged var p_latitude: NSNumber?
    @NSManaged var p_longitude: NSNumber?
    @NSManaged public var name: String?
    @NSManaged var p_not_currently_available: NSNumber?
    @NSManaged public var post_code: String?
    @NSManaged public var province: String?
    @NSManaged public var street: String?
    @NSManaged var p_uid: NSNumber?
    @NSManaged public var sent_messages: NSSet?
    @NSManaged public var threads: NSSet?
    @NSManaged public var map_tile: MOMapTile?

}
