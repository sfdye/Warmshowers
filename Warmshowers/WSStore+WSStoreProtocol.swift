//
//  WSStore+WSStoreProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 8/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

extension WSStore : WSStoreProtocol {
    
    func clearout() throws {
        
        // Cycle through entities and delete all entries.
        let entities = WSEntity.allValues
        do {
            for entity in entities {
                let objects = try getAllEntriesFromEntity(entity) as! [NSManagedObject]
                for object in objects {
                    privateContext.delete(object)
                    try savePrivateContext()
                }
            }
        }
    }
}
