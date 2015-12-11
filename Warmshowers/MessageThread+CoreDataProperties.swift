//
//  MessageThread+CoreDataProperties.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MessageThread {

    @NSManaged var count: NSNumber?
    @NSManaged var has_tokens: NSNumber?
    @NSManaged var is_new: NSNumber?
    @NSManaged var last_updated: NSNumber?
    @NSManaged var subject: String?
    @NSManaged var thread_id: NSNumber?
    @NSManaged var thread_started: NSNumber?
    @NSManaged var participants: NSSet?

}
