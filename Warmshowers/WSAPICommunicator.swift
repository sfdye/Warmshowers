//
//  WSAPICommunicator.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class WSAPICommunicator : WSAPICommunicatorProtocol {
    
    static let sharedAPICommunicator = WSAPICommunicator()
    
    func sendFeedback(feedback: WSRecommendation, andNotify sender: WSAPIResponseHandler?) {
        let feedbackSender = WSFeedbackSender(
            feedback: feedback,
            success: { () -> Void in
                sender?.didRecieveAPISuccessResponse(nil)
            },
            failure: {(error) -> Void in
                sender?.didRecieveAPIFailureResponse(error)
            }
        )
        feedbackSender.send()
    }
}