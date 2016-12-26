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

    @NSManaged var additional: String?
    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var p_distance: NSNumber?
    @NSManaged var fullname: String?
    @NSManaged var image: NSObject?
    @NSManaged var image_url: String?
    @NSManaged var p_latitude: NSNumber?
    @NSManaged var p_longitude: NSNumber?
    @NSManaged var name: String?
    @NSManaged var p_not_currently_available: NSNumber?
    @NSManaged var post_code: String?
    @NSManaged var province: String?
    @NSManaged var street: String?
    @NSManaged var p_uid: NSNumber?
    @NSManaged var sent_messages: NSSet?
    @NSManaged var threads: NSSet?
    @NSManaged var map_tile: MOMapTile?

}
