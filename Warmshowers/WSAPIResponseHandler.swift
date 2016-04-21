//
//  WSAPIResponseHandler.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSAPIResponseHandler {
    func didRecieveAPISuccessResponse(data: AnyObject?)
    func didRecieveAPIFailureResponse(error: ErrorType?)
}