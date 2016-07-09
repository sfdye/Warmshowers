//
//  WSHostListTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostListTableViewController : WSAPIResponseDelegate {
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        guard let hosts = hosts else { return }
        let image = data as? UIImage
        for (index, host) in hosts.enumerate() {
            if host.imageURL == request.endPoint.path {
                host.image = image ?? placeholderImage
                dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                    self?.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .None)
                    })
            }
        }
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        // No need for action.
    }
}