//
//  ContentType.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public enum ContentType: String {
    case plainText = "text/plain"
    case json = "application/json"
    case xWWWFormURLEncoded = "application/x-www-form-urlencoded; charset=utf-8"
    case image = "image/*"
}
