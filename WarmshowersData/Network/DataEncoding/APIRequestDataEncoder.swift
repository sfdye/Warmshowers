//
//  APIRequestDataEncoder.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 23/12/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public protocol APIRequestDataEncoder {
    
    /** Encodes outbound data for HTTP request bodies. */
    func body(fromParameters parameters: [String: String]) throws -> Data
    
}
