//
//  CDWSUser.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 4/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

enum CDWSMessageParticipantError : ErrorType {
    case FailedValueForKey(key: String)
}

class CDWSUser: NSManagedObject {
    
    func updateFromMessageParticipantJSON(json: AnyObject) throws {
        
        guard let fullname = json.valueForKey("fullname") as? String else {
            throw CDWSMessageParticipantError.FailedValueForKey(key: "fullname")
        }
        
        guard let name = json.valueForKey("name") as? String else {
            throw CDWSMessageParticipantError.FailedValueForKey(key: "name")
        }
        
        guard let uid = json.valueForKey("uid")?.integerValue else { 
            throw CDWSMessageParticipantError.FailedValueForKey(key: "uid")
        }
        
        self.fullname = fullname
        self.name = name
        self.uid = uid
        
    }
    
    func updateFromJSON(json: AnyObject) {
        
        self.fullname = json.valueForKey("fullname") as? String
        self.name = json.valueForKey("name") as? String
        self.uid = json.valueForKey("uid")?.integerValue
        
    }
    
}