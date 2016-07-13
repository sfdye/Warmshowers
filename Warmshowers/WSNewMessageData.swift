//
//  WSNewMessageData.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSNewMessageData {
    
    var recipientsString: String
    var subject: String
    var body: String
    
    init(recipientsString: String, subject: String, body: String) {
        self.recipientsString = recipientsString
        self.subject = subject
        self.body = body
    }
    
}