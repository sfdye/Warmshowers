//
//  LocationSearchViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 11/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension LocationSearchViewController : APIResponseDelegate {
    
    func requestDidComplete(_ request: APIRequest) {
        guard let tile = request.data as? MapTile else { return }
        downloadDidEndForMapTile(tile)
    }
    
    func request(_ request: APIRequest, didSuceedWithData data: Any?) {
        guard let tile = request.data as? MapTile else { return }
        loadAnnotationsForMapTile(tile)
    }
    
    func request(_ request: APIRequest, didFailWithError error: Error) {
        switch error {
        case is APIEndPointError:
            switch (error as! APIEndPointError) {
            case .reachedTileLimit:
                // Tile has the maximum number of users on it and needs to sub-divided.
                guard let tile = request.data as? MapTile else { return }
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
