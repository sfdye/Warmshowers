//
//  User+CoreDataProperties.swift
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

extension User {

    @NSManaged var fullname: String?
    @NSManaged var name: String?
    @NSManaged var uid: NSNumber?

}