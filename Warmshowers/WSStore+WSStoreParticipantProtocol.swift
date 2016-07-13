//
//  WSStore+Participants.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

extension WSStore : WSStoreParticipantProtocol {
    
    func allMessageParticipants() throws -> [CDWSUser] {
        do {
            let users = try getAllEntriesFromEntity(.Participant) as! [CDWSUser]
            return users
        }
    }
    
    func participantWithID(uid: Int) throws -> CDWSUser? {
        
        let request = requestForEntity(.Participant)
        request.predicate = NSPredicate(format: "uid == %i", uid)
        
        do {
            let user = try executeFetchRequest(request).first as? CDWSUser
            return user
        }
    }
    
    func newOrExistingParticipant(uid: Int) throws -> CDWSUser {
        do {
            if let user = try participantWithID(uid) {
                return user
            } else {
                let user = NSEntityDescription.insertNewObjectForEntityForName(WSEntity.Participant.rawValue, inManagedObjectContext: privateContext) as! CDWSUser
                return user
            }
        }
    }
    
    func participantSetFromJSON(json: AnyObject) throws -> NSSet {
        
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
    
    func addParticipantWithJSON(json: AnyObject) throws {
        
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
    
    func updateParticipantImageURLWithJSON(json: AnyObject) throws {
        
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
    
    func updateParticipant(uid: Int, withImage image: UIImage) throws {
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
    
    func updateParticipantWithImageURL(imageURL: String, withImage image: UIImage) {
        
        let request = requestForEntity(.Participant)
        request.predicate = NSPredicate(format: "image_url LIKE %@", imageURL)
        
        do {
            let user = try executeFetchRequest(request).first as? CDWSUser
            user?.image = image
            try savePrivateContext()
        } catch {
            // No an important failure.
        }
    }
    
}