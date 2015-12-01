//
//  MessageParticipant.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

class MessageParticipant : NSObject {
    
    var fullname: String? = nil
    var name: String? = nil
    var uid: Int? = nil
    
    class func initFromJSONObject(json: AnyObject?) -> MessageParticipant? {

        guard let json = json else {
            return nil
        }
        
        guard let jsonDict = json as? NSDictionary else {
            print("Dictionary conversion failure")
            return nil
        }
        
        guard let fullname = jsonDict["fullname"] as? String else {
            print("Failed MessageParticipant initialisation for key 'fullname'")
            return nil
        }
        
        guard let name = jsonDict["name"] as? String else {
            print("Failed MessageParticipant initialisation for key 'name'")
            return nil
        }
        
        guard let uid_String = jsonDict["uid"] as? String else {
            print("Failed MessageParticipant initialisation for key 'uid'")
            return nil
        }
        
        guard let uid = Int(uid_String) else {
            print("Failed casting the uid from String to Int")
            return nil
        }
        
        let mp = MessageParticipant()
        
        mp.fullname = fullname
        mp.name = name
        mp.uid = uid
        
        return mp
    }
    
    class func arrayFromJSONObjects(json: AnyObject?) -> [MessageParticipant]? {
        
        guard let json = json else {
            return nil
        }
        
        guard let participants = json as? NSArray else {
            return nil
        }
        
        var mpa = [MessageParticipant]()
        
        for participant in participants {
            if let mp = MessageParticipant.initFromJSONObject(participant) {
                mpa.append(mp)
            }
        }
        
        return mpa
    }
}