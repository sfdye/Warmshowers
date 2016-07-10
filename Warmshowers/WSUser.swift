//
//  File.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 20/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSUser: Hashable {
    
    var fullname: String
    var name: String
    var uid: Int
    var phoneNumbers: WSPhoneNumbers?
    
    // MARK: Hashable
    
    var hashValue: Int { return uid }
    
    // MARK: Initialisers
    
    init(fullname: String, name: String, uid: Int) {
        self.fullname = fullname
        self.name = name
        self.uid = uid
    }
    
    convenience init?(json: AnyObject) {
        
        guard
            let fullname = json["fullname"] as? String,
            let name = json["name"] as? String,
            let uidString = json["uid"] as? String,
            let uid = Int(uidString)
            else {
                return nil
        }
        
        self.init(fullname: fullname, name: name, uid: uid)
    }
}

func ==(lhs: WSUser, rhs: WSUser) -> Bool {
    return lhs.hashValue == rhs.hashValue
}


