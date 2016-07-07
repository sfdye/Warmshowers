//
//  CDWSMessageThread+CoreDataProperties.swift
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

extension CDWSMessageThread {

    @NSManaged var count: NSNumber?
    @NSManaged var has_tokens: NSNumber?
    @NSManaged var is_new: NSNumber?
    @NSManaged var last_updated: NSDate?
    @NSManaged var subject: String?
    @NSManaged var thread_id: NSNumber?
    @NSManaged var thread_started: NSDate?
    @NSManaged var messages: NSSet?
    @NSManaged var participants: NSSet?

}
