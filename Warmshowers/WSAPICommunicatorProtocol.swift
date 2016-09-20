//
//  WSAPICommunicatorProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 21/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSAPICommunicatorProtocol {
    func contactEndPoint(_ endPoint: WSAPIEndPoint, withPathParameters parameters: Any?, andData data: Any?, thenNotify requester: WSAPIResponseDelegate)
}
