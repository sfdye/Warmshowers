//
//  APIAuthorizer.swift
//  Powershop
//
//  Created by Rajan Fernandez on 14/07/16.
//  Copyright © 2016 Powershop. All rights reserved.
//

import Foundation

class APIAuthorizer {
    
    let outboundDataMethods: [HTTP.Method] = [.post, .put, .delete, .patch]
    
    var currentlyReauthorizing = false
    
    weak var delegate: APILoginResponseDelegate?
    
}

