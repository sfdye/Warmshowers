//
//  WSAPIEndPoint.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

enum WSAPIEndPoint {
    case Token
    case Login
    case Logout
    case SearchByLocation
    case SearchByKeyword
    case UserInfo
    case UserFeedback
    case CreateFeedback
    case NewMessage
    case ReplyToMessage
    case UnreadMessageCount
    case GetAllMessageThreads
    case GetMessageThread
    case MarkMessage
}