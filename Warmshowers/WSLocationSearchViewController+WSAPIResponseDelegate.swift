//
//  WSLocationSearchViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 11/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSLocationSearchViewController : WSAPIResponseDelegate {
    
    func requestDidComplete(_ request: WSAPIRequest) {
        guard let tile = request.data as? WSMapTile else { return }
        downloadDidEndForMapTile(tile)
    }
    
    func request(_ request: WSAPIRequest, didSuceedWithData data: Any?) {
        guard let tile = request.data as? WSMapTile else { return }
        loadAnnotationsForMapTile(tile)
    }
    
    func request(_ request: WSAPIRequest, didFailWithError error: Error) {
        switch error {
        case is WSAPIEndPointError:
            switch (error as! WSAPIEndPointError) {
            case .reachedTileLimit:
                // Tile has the maximum number of users on it and needs to sub-divided.
                guard let tile = request.data as? WSMapTile else { return }
                let tiles = tile.subtiles
                for tile in tiles {
                    loadAnnotationsForMapTile(tile)
                }
            default:
                break
            }
        default:
            if downloadsInProgress.count == 0 {
                alert.presentAPIError(error, forDelegator: self)
            }
        }
    }
    
}
