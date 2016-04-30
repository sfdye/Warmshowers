//
//  WSEndPointFactory.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

/**
 Factory class for choosing an API service.
 */
class WSAPIEndPointFactory {
    static func endPointWithEndPoint(endPoint: WSAPIEndPoint, andUID uid: Int? = nil) -> WSAPIEndPointProtocol {
        switch endPoint {
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