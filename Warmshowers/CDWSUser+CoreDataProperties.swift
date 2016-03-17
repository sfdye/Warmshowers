//
//  CDWSUser+CoreDataProperties.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDWSUser {

    @NSManaged var additional: String?
    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var distance: NSNumber?
    @NSManaged var fullname: String?
    @NSManaged var image: NSObject?
    @NSManaged var image_url: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var name: String?
    @NSManaged var notcurrentlyavailable: NSNumber?
    @NSManaged var post_code: String?
    @NSManaged var province: String?
    @NSManaged var street: String?
    @NSManaged var uid: NSNumber?
    @NSManaged var sent_messages: NSSet?
    @NSManaged var threads: NSSet?
    @NSManaged var map_tile: CDWSMapTile?

}
