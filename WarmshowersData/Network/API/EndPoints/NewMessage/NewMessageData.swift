//
//  NewMessageData.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public class NewMessageData {
    
    var recipientsString: String
    var subject: String
    var body: String
    
    public init(recipientsString: String, subject: String, body: String) {
        self.recipientsString = recipientsString
        self.subject = subject
        self.body = body
    }
    
}
