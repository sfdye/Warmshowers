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
        case .CreateFeedback:
            return WSCreateFeedbackEndPoint.sharedEndPoint
            
        // CHANGE THIS DEFAULT LATER
        default:
            return WSCreateFeedbackEndPoint.sharedEndPoint
        }
    }
}