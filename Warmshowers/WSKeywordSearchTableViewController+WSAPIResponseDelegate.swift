//
//  WSKeywordSearchTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSKeywordSearchTableViewController : WSAPIResponseDelegate {
    
    func request(_ request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        switch request.endPoint.type {
        case .searchByKeyword:
            reloadTableWithHosts(data as? [WSUserLocation])
        case .imageResource:
            guard let hosts = hosts else { break }
            let image = data as? UIImage
            for (index, host) in hosts.enumerated() {
                if host.imageURL == request.endPoint.path {
                    host.image = image ?? placeholderImage
                    DispatchQueue.main.async(execute: { [weak self] () -> Void in
                        self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    })
                }
            }
        default:
            break
        }
    }
    
    func request(_ request: WSAPIRequest, didFailWithError error: ErrorProtocol) {
        reloadTableWithHosts([WSUserLocation]())
    }
}
