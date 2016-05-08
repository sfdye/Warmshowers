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
    
    var getTokenCalled = false
    var loginCalled = false
    var logoutCalled = false
    var createFeedbackCalled = false
    var searchByLocationCalled = false
    var searchByKeywordCalled = false
    
    func getTokenAndNotify(requester: WSAPIResponseDelegate) {
        getTokenCalled = true
    }
    
    func login(username: String, password: String, andNotify: WSAPIResponseDelegate) {
        loginCalled = true
    }
    
    func logoutAndNotify(requester: WSAPIResponseDelegate) {
        logoutCalled = true
    }
    
    func createFeedback(feedback: WSRecommendation, andNotify: WSAPIResponseDelegate) {
        createFeedbackCalled = true
    }
    
    func searchByLocation(regionLimits: [String: String], andNotify requester: WSAPIResponseDelegate) {
        searchByLocationCalled = true
    }
    
    func searchByKeyword(keyword: String, offset: Int, andNotify requester: WSAPIResponseDelegate) {
        searchByKeywordCalled = true
    }
}