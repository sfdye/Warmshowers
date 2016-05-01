//
//  WSAPICommunicatorProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSAPICommunicatorProtocol {
    func getTokenAndNotify(requester: WSAPIResponseDelegate)
    func login(username: String, password: String, andNotify requester: WSAPIResponseDelegate)
    func logoutAndNotify(requester: WSAPIResponseDelegate)
    func createFeedback(feedback: WSRecommendation, andNotify requester: WSAPIResponseDelegate)
    func searchByLocation(regionLimits: [String: String], andNotify requester: WSAPIResponseDelegate)
    func searchByKeyword(keyword: String, offset: Int, andNotify requester: WSAPIResponseDelegate)
}