//
//  User.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

enum MessageParticipantError : ErrorType {
    case FailedValueForKey(key: String)
}

class User: NSManagedObject {
    
    func updateFromMessageParticipantJSON(json: AnyObject) throws {
        
        guard let fullname = json.valueForKey("fullname") as? String else {
            throw MessageThreadError.FailedValueForKey(key: "count")
        }
        
        guard let name = json.valueForKey("name") as? String else {
            throw MessageThreadError.FailedValueForKey(key: "count")
        }
        
        guard let uid = json.valueForKey("uid")?.integerValue else {
            throw MessageThreadError.FailedValueForKey(key: "count")
        }
        
        self.fullname = fullname
        self.name = name
        self.uid = uid
 
    }
}
