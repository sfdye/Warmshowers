//
//  CDWSMessage+CoreDataProperties.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 23/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDWSMessage {

    @NSManaged var body: String?
    @NSManaged var is_new: NSNumber?
    @NSManaged var message_id: NSNumber?
    @NSManaged var timestamp: NSDate?
    @NSManaged var author: CDWSUser?
    @NSManaged var recipients: NSSet?
    @NSManaged var thread: CDWSMessageThread?

}
