//
//  CDWSUser+CoreDataProperties.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDWSUser {

    @NSManaged var fullname: String?
    @NSManaged var image: NSObject?
    @NSManaged var name: String?
    @NSManaged var uid: NSNumber?
    @NSManaged var image_url: String?
    @NSManaged var recieved_messages: NSSet?
    @NSManaged var sent_messages: NSSet?
    @NSManaged var threads: NSSet?

}
