//
//  WSEntity.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

enum WSEntity : String {
    case Thread = "MessageThread"
    case Message = "Message"
    case Participant = "Participant"
    case MapTile = "MapTile"
    case UserLocation = "UserLocation"
    static let allValues = [Thread, Message, Participant, MapTile, UserLocation]
}