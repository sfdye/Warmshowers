//
//  CDWSMessage+CoreDataProperties.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 5/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDWSMessage {

    @NSManaged var body: String?
    @NSManaged var author_uid: NSNumber?
    @NSManaged var message_id: NSNumber?
    @NSManaged var timestamp: NSDate?
    @NSManaged var is_new: NSNumber?
    @NSManaged var thread: CDWSMessageThread?
    @NSManaged var author: CDWSUser?

}
