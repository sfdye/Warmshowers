//
//  Message+CoreDataProperties.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 2/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Message {

    @NSManaged var body: String?
    @NSManaged var thread: MessageThread?

}
