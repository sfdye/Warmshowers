//
//  WSAPIRequestStatus.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 8/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSAPIRequestStatus {
    case Created
    case Queued
    case Sent
    case RecievedResponse
    case Parsing
}