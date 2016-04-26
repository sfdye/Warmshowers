//
//  WSMOCKAPICommunicator.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
@testable import Warmshowers

class WSMOCKAPICommunicator : WSAPICommunicatorProtocol {
    
    static let sharedAPICommunicator = WSMOCKAPICommunicator()
    
    var sendFeedbackCalled = false
    
    func sendFeedback(feedback: WSRecommendation, andNotify sender: WSAPIResponseDelegate) {
        print("IN MOCK")
        sendFeedbackCalled = true
    }
    
    func reset() {
        sendFeedbackCalled = false
    }
}