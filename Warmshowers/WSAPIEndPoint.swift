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
    
    /** Returns the shared instance of the end point */
    var sharedEndPoint: WSAPIEndPointProtocol {
        switch self {
        case .Token:
            return WSTokenEndPoint.sharedEndPoint
        case .Login:
            return WSLoginEndPoint.sharedEndPoint
        case .Logout:
            return WSLogoutEndPoint.sharedEndPoint
        case .SearchByLocation:
            assertionFailure("End point not added to factory")
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .SearchByKeyword:
            return WSSearchByKeywordEndPoint.sharedEndPoint
        case .UserInfo:
            assertionFailure("End point not added to factory")
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .UserFeedback:
            assertionFailure("End point not added to factory")
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .CreateFeedback:
            return WSCreateFeedbackEndPoint.sharedEndPoint
        case .NewMessage:
            assertionFailure("End point not added to factory")
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .ReplyToMessage:
            assertionFailure("End point not added to factory")
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .UnreadMessageCount:
            assertionFailure("End point not added to factory")
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .GetAllMessageThreads:
            assertionFailure("End point not added to factory")
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .GetMessageThread:
            assertionFailure("End point not added to factory")
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        case .MarkMessage:
            assertionFailure("End point not added to factory")
            return WSCreateFeedbackEndPoint.sharedEndPoint // NEEDS CHANGE
        }
    }
}