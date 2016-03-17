//
//  WSEntity.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSEntity : String {
    case Thread = "MessageThread"
    case Message = "Message"
    case User = "User"
    case MapTile = "MapTile"
    static let allValues = [Thread, Message, User, MapTile]
}