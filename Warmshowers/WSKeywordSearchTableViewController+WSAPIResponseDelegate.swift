//
//  WSKeywordSearchTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSKeywordSearchTableViewController : WSAPIResponseDelegate {
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        switch request.endPoint.type {
        case .SearchByKeyword:
            reloadTableWithHosts(data as? [WSUserLocation])
        case .ImageResource:
            guard let hosts = hosts else { break }
            let image = data as? UIImage
            for (index, host) in hosts.enumerate() {
                if host.thumbnailImageURL == request.endPoint.path {
                    host.thumbnailImage = image ?? placeholderImage
                    dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                        self?.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .None)
                    })
                }
            }
        default:
            break
        }
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        reloadTableWithHosts([WSUserLocation]())
    }
}
