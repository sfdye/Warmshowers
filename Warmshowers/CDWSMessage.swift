//
//  CDWSMessage.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 4/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

enum CDWSMessageError : ErrorType {
    case FailedValueForKey(key: String)
}

class CDWSMessage: NSManagedObject {
    
    var authorName: String? {
        if let author = self.author {
            return author.fullname
        } else {
            return nil
        }
    }
    
    var authorThumbnail: UIImage? {
        if let author = self.author {
            return author.image as? UIImage
        } else {
            return nil
        }
    }
    
    // Updates all fields of the message thread with JSON data
    //
    func updateWithJSON(json: AnyObject) throws {
        
        guard let body = json.valueForKey("body") as? String else {
            throw CDWSMessageThreadError.FailedValueForKey(key: "count")
        }
        
        guard let message_id = json.valueForKey("mid")?.integerValue else {
            throw CDWSMessageThreadError.FailedValueForKey(key: "mid")
        }
        
        guard let timestamp = json.valueForKey("timestamp")?.doubleValue else {
            throw CDWSMessageThreadError.FailedValueForKey(key: "timestamp")
        }
        
        guard let is_new = json.valueForKey("is_new")?.boolValue else {
            throw CDWSMessageThreadError.FailedValueForKey(key: "is_new")
        }
        
        self.body = body
        self.message_id = message_id
        self.timestamp = NSDate(timeIntervalSince1970: timestamp)
        self.is_new = is_new
    }
}
