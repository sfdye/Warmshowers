//
//  MessageThread.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/12/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

class MessageThread : NSObject {
    
    var count: Int = 0
    var has_tokens: Bool = false
    var is_new: Bool = false
    var last_updated: Int = 0
    var participants: [MessageParticipant] = [MessageParticipant]()
    var subject: String? = nil
    var thread_id: Int? = nil
    var thread_started: Int? = nil
    
    class func initFromJSONObject(json: AnyObject) -> MessageThread? {
        
        guard let count = json.valueForKey("count")?.integerValue else {
            return nil
        }
        
        guard let has_tokens = json.valueForKey("has_tokens")?.boolValue else {
            return nil
        }
        
        guard let is_new = json.valueForKey("is_new")?.boolValue else {
            return nil
        }
        
        guard let last_updated = json.valueForKey("last_updated")?.integerValue else {
            return nil
        }
        
        guard let participants = MessageParticipant.arrayFromJSONObjects(json.valueForKey("participants")) else {
            return nil
        }
        
        guard let subject = json.valueForKey("subject") as? String else {
            return nil
        }
        
        guard let thread_id = json.valueForKey("thread_id")?.integerValue else {
            return nil
        }
        
        guard let thread_started = json.valueForKey("thread_started")?.integerValue else {
            return nil
        }
        
        let mt = MessageThread()
        
        mt.count = count
        mt.has_tokens = has_tokens
        mt.is_new = is_new
        mt.last_updated = last_updated
        mt.participants = participants
        mt.subject = subject
        mt.thread_id = thread_id
        mt.thread_started = thread_started
        
        return mt
    
    }
    
    func getParticipantString() -> String {
        
        var pString = ""
        
        for participant in participants {
            
            if pString != "" {
                pString += ", "
            }
            if let name = participant.fullname {
                pString += name
            }
            
        }
        
        return pString
    }

}