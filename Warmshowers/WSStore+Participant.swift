//
//  WSStore+Participants.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

extension WSStore {
    
    // MARK: User handling methods
    
    // Returns all the users in the store
    //
    class func allMessageParticipants() throws -> [CDWSUser] {
        
        do {
            let users = try getAllFromEntity(.Participant) as! [CDWSUser]
            return users
        }
    }
    
    // Checks if a user is already in the store by uid.
    //
    class func participantWithID(uid: Int) throws -> CDWSUser? {
        
        let request = requestForEntity(.Participant)
        request.predicate = NSPredicate(format: "uid == %i", uid)
        
        do {
            let user = try executeFetchRequest(request).first as? CDWSUser
            return user
        }
    }
    
    // Returns an existing user, or a new user inserted into the private context.
    //
    class func newOrExistingParticipant(uid: Int) throws -> CDWSUser {
        do {
            if let user = try participantWithID(uid) {
                return user
            } else {
                let user = NSEntityDescription.insertNewObjectForEntityForName(WSEntity.Participant.rawValue, inManagedObjectContext: sharedStore.privateContext) as! CDWSUser
                return user
            }
        }
    }
    
    // Create a user set from json containing message thread participants
    //
    class func participantSetFromJSON(json: AnyObject) throws -> NSSet {
        
        guard let users = json as? NSArray else {
            throw DataError.InvalidInput
        }
        
        var participants = [CDWSUser]()
        for user in users {
            
            // Get the user uid of the message participant.
            if let uid = user.valueForKey("uid")?.integerValue {
                
                // Check if the participant exists in the store.
                do {
                    var participant = try participantWithID(uid)
                    if participant == nil {
                        try addParticipantWithJSON(user)
                        participant = try participantWithID(uid)
                    }
                    participants.append(participant!)
                }
                
            } else {
                throw DataError.InvalidInput
            }
        }
        
        return NSSet(array: participants)
    }
    
    // Adds a user to the store with json describing a message participant
    //
    class func addParticipantWithJSON(json: AnyObject) throws {
        
        guard let fullname = json.valueForKey("fullname") as? String else {
            throw CDWSUserError.FailedValueForKey(key: "fullname")
        }
        
        guard let name = json.valueForKey("name") as? String else {
            throw CDWSUserError.FailedValueForKey(key: "name")
        }
        
        guard let uid = json.valueForKey("uid")?.integerValue else {
            throw CDWSUserError.FailedValueForKey(key: "uid")
        }
        
        do {
            let user = try newOrExistingParticipant(uid)
            user.fullname = fullname
            user.name = name
            user.uid = uid
            try savePrivateContext()
        }
    }
    
    // Updates a users profile thumbnail image url
    class func updateParticipantImageURLWithJSON(json: AnyObject) throws {
        
        guard let uid = json.valueForKey("uid")?.integerValue else {
            throw DataError.InvalidInput
        }
        
        do {
            if let user = try participantWithID(uid) {
                user.image_url = json.valueForKey("profile_image_map_infoWindow") as? String
                try savePrivateContext()
            } else {
                let error = NSError(domain: "WSStore", code: 1, userInfo: [NSLocalizedDescriptionKey : "Can not update image url for user. User is not in the store."])
                throw error
            }
        }
    }
    
    // Update a user with a thumbnail image
    class func updateParticipant(uid: Int, withImage image: UIImage) throws {
        
        do {
            if let user = try participantWithID(uid) {
                user.image = image
                try savePrivateContext()
            } else {
                let error = NSError(domain: "WSStore", code: 2, userInfo: [NSLocalizedDescriptionKey : "Can not update image for user. User is not in the store."])
                throw error
            }
        }
    }
    
}