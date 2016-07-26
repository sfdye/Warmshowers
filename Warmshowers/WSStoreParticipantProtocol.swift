//
//  WSStoreParticipantProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 8/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

protocol WSStoreParticipantProtocol {
    
    func allMessageParticipants() throws -> [CDWSUser]
    
    func participantWithID(uid: Int) throws -> CDWSUser?
    
    func newOrExistingParticipant(uid: Int) throws -> CDWSUser
    
    func participantSetFromJSON(json: AnyObject) throws -> NSSet
    
    func addParticipantWithJSON(json: AnyObject) throws
    
    func updateParticipant(uid: Int, withImageURL imageURL: String) throws
    
    func addParticipant(newUser: WSUser) throws
    
    func updateParticipant(uid: Int, withImage image: UIImage) throws
    
    func updateParticipantWithImageURL(imageURL: String, withImage image: UIImage)
    
}