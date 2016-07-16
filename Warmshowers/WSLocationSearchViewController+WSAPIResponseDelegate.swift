//
//  WSLocationSearchViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 11/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSLocationSearchViewController : WSAPIResponseDelegate {
    
    func requestDidComplete(request: WSAPIRequest) {
        guard let tile = request.data as? WSMapTile else { return }
        downloadDidEndForMapTile(tile)
    }
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        guard let tile = request.data as? WSMapTile else { return }
        if let users = data as? [WSUserLocation] {
            tile.users = users
            tile.last_updated = NSDate()
            addUsersToMapWithMapTile(tile)
        }
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        alert.presentAPIError(error, forDelegator: self)
    }
    
}
