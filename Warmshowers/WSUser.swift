//
//  File.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 20/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSUser : NSObject {
    
    var fullname: String
    var name: String
    var uid: Int
    
    init(fullname: String, name: String, uid: Int) {
        self.fullname = fullname
        self.name = name
        self.uid = uid
    }
    
    // Method to initialise from a JSON object
    //
    convenience init?(json: AnyObject) {
        
        guard let fullname = json.valueForKey("fullname") as? String,
              let name = json.valueForKey("name") as? String,
              let uid = json.valueForKey("laundry")?.integerValue
            else {
                return nil
        }
        
        self.init(fullname: fullname, name: name, uid: uid)
    }

}
