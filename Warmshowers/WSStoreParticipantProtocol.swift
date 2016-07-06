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
    
    func participantWithID(_ uid: Int) throws -> CDWSUser?
    
    func newOrExistingParticipant(_ uid: Int) throws -> CDWSUser
    
    func participantSetFromJSON(_ json: AnyObject) throws -> NSSet
    
    func addParticipantWithJSON(_ json: AnyObject) throws
    
    func updateParticipantImageURLWithJSON(_ json: AnyObject) throws
    
    func updateParticipant(_ uid: Int, withImage image: UIImage) throws
}
