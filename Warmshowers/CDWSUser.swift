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

class CDWSUser: NSManagedObject, WSLazyImage {
    
    static let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // MARK: WSLazyImage Protocol
    
    var lazyImageURL: String? {
        get {
            return image_url
        }
    }
    var lazyImage: UIImage? {
        get {
            return image as? UIImage
        }
        set(newImage) {
            image = newImage
        }
    }
    
    // MARK: Instance methods
    
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
        self.image_url = json.valueForKey("profile_image_map_infoWindow") as? String
    }
    
    // Checks if a user is already in the store by uid.
    // Returns the existing user, or a new user inserted into the MOC.
    //
    static func userWithUID(uid: Int) -> CDWSUser? {
        
        let request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "uid == %i", uid)
        
        // Try to find the user in the store
        do {
            if let user = try moc.executeFetchRequest(request).first as? CDWSUser {
                return user
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    static func newOrExistingUser(uid: Int) -> CDWSUser {
        if let user = userWithUID(uid) {
            return user
        } else {
            let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as! CDWSUser
            return user
        }
    }
    
    static func userSetFromJSON(json: AnyObject) throws -> NSSet {
            
        guard let users = json as? NSArray else {
            throw DataError.FailedConversion
        }
        
        var participants = [CDWSUser]()
        for user in users {
            
            // Get the user uid of the message participant.
            if let uid = user.valueForKey("uid")?.integerValue {
                
                // Check if the participant exists in the store.
                let participant = newOrExistingUser(uid)
                do {
                    try participant.updateFromMessageParticipantJSON(user)
                    participants.append(participant)
                }
                
            } else {
                throw DataError.InvalidInput
            }
        }
        
        return NSSet(array: participants)
    }

}
