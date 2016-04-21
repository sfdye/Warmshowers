//
//  WSAPICommunicatorProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSAPICommunicatorProtocol {
    func sendFeedback(feedback: WSRecommendation, andNotify: WSAPIResponseHandler?)
}