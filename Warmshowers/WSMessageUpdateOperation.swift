//
//  WSMessageUpdateOperation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSMessageUpdateOperation : NSOperation {
    
    var messageUpdater: WSMessageUpdater!
    
    init(messageUpdater: WSMessageUpdater) {
        super.init()
        self.messageUpdater = messageUpdater
    }
    
    override func main() {
        
        // Start the updater
        messageUpdater.update()
    }
    
}