//
//  MOMessageThread+CoreDataProperties.swift
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

extension MOMessageThread {

    @NSManaged var p_count: NSNumber?
    @NSManaged var p_has_tokens: NSNumber?
    @NSManaged var p_is_new: NSNumber?
    @NSManaged public var last_updated: Date?
    @NSManaged public var subject: String?
    @NSManaged var p_thread_id: NSNumber?
    @NSManaged public var thread_started: Date?
    @NSManaged public var messages: NSSet?
    @NSManaged public var participants: NSSet?

}
