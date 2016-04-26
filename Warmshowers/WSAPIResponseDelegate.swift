//
//  WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 22/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSAPIResponseDelegate {
    func didRecieveAPISuccessResponse(data: AnyObject?)
    func didRecieveAPIFailureResponse(error: ErrorType?)
}