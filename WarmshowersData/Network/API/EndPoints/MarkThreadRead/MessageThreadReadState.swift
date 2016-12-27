//
//  MessageThreadReadState.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public class MessageThreadReadState {
    
    public var threadID: Int
    public var read: Bool
    
    public init(threadID: Int, read: Bool) {
        self.threadID = threadID
        self.read = read
    }
    
}
