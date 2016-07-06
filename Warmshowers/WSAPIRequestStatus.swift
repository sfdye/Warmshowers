//
//  WSAPIRequestStatus.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 8/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSAPIRequestStatus {
    case created
    case queued
    case sent
    case recievedResponse
    case parsing
}
