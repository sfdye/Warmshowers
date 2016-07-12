//
//  WSLocationSearchViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 11/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSLocationSearchViewController : WSAPIResponseDelegate {
    
    func requestdidComplete(request: WSAPIRequest) {
        guard let tile = request.data as? WSMapTile else { return }
        downloadDidEndForMapTile(tile)
    }
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        if let users = data as? [WSUserLocation] {
            addUsersToMap(users)
        }
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        alert.presentAPIError(error, forDelegator: self)
    }
    
}
