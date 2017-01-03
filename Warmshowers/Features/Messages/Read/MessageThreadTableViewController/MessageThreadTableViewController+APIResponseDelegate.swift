//
//  MessageThreadTableViewController+APIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import WarmshowersData

extension MessageThreadTableViewController: APIResponseDelegate {
    
    func requestDidComplete(_ request: APIRequest) {
        switch request.endPointType {
        case .messageThread:
            DispatchQueue.main.async(execute: { [unowned self] in
                self.refreshControl?.endRefreshing()
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
            guard let readState = request.data as? MessageThreadReadState else { return }
            let predicate = NSPredicate(format: "p_thread_id == %d", readState.threadID)
            if let messageThread: MOMessageThread = try! store.retrieve(inContext: store.managedObjectContext, withPredicate: predicate, andSortBy: nil, isAscending: true).first {
                messageThread.is_new = !readState.read
                try! store.managedObjectContext.save()
            }
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
                    api.contact(endPoint: .imageResource, withMethod: .get, andPathParameters: url, andData: nil, thenNotify: self)
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
        //
    }
    
}
