//
//  ReplyMessageData.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class ReplyMessageData {
    
    var threadID: Int
    var body: String
    
    init(threadID: Int, body: String) {
        self.threadID = threadID
        self.body = body
    }
    
}
