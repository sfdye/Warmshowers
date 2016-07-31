//
//  WSMOMessage+CoreDataProperties.swift
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

extension WSMOMessage {

    @NSManaged var body: String?
    @NSManaged var p_is_new: NSNumber?
    @NSManaged var p_message_id: NSNumber?
    @NSManaged var timestamp: NSDate?
    @NSManaged var author: WSMOUser?
    @NSManaged var thread: WSMOMessageThread?

}
