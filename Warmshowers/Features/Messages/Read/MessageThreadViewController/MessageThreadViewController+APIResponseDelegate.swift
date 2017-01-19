//
//  MessageThreadViewController+APIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import WarmshowersData

extension MessageThreadViewController: APIResponseDelegate {
    
    func requestDidComplete(_ request: APIRequest) {
        switch request.endPointType {
        case .messageThread:
            DispatchQueue.main.async(execute: { [unowned self] in
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            })
        case .user:
            guard let uid = request.parameters as? String else { return }
            downloadsInProgress.remove(uid)
        default:
            break
        }
    }
    
    func request(_ request: APIRequest, didSucceedWithData data: Any?) {
        switch request.endPointType {
        case .markThreadRead:
            // No futher action required.
            break
        case .user:
            guard
                let user = data as? User,
                let url = user.profileImageURL
                else { return }
            let predicate = NSPredicate(format: "p_uid == %d", user.uid)
            if let user: MOUser = try! store.retrieve(inContext: store.managedObjectContext, withPredicate: predicate, andSortBy: nil, isAscending: true).first {
                user.image_url = url
                do {
                    try store.managedObjectContext.save()
                    api.contact(endPoint: .imageResource, withMethod: .get, andPathParameters: url, andData: nil, thenNotify: self, ignoreCache: false)
                } catch {
                    // Not a big deal. The author profile image won't be downloaded.
                }
            }
        case .imageResource:
            guard
                let image = data as? UIImage,
                let url = request.parameters as? String
                else { return }
            setImage(image, forHostWithImageURL: url)
        default:
            break
        }
    }
    
    func request(_ request: APIRequest, didFailWithError error: Error) {
        // Not a big deal if requests fail here.
    }
    
}
