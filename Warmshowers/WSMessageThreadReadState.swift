//
//  WSMessageThreadReadState.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSMessageThreadReadState {
    
    var threadID: Int
    var read: Bool
    
    init(threadID: Int, read: Bool) {
        self.threadID = threadID
        self.read = read
    }
}