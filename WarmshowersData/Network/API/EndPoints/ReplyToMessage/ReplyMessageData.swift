//
//  ReplyMessageData.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public class ReplyMessageData {
    
    public private(set) var threadID: Int
    public private(set) var body: String
    
    public init(threadID: Int, body: String) {
        self.threadID = threadID
        self.body = body
    }
    
}
