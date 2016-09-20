//
//  WSMessageThreadTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSMessageThreadTableViewController: WSAPIResponseDelegate {
    
    func requestDidComplete(_ request: WSAPIRequest) {
        switch request.endPoint.type {
        case .GetMessageThread:
            DispatchQueue.main.async(execute: { [weak self] in
                self?.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            })
        case .UserInfo:
            guard let uid = request.parameters as? String else { return }
            downloadsInProgress.remove(uid)
        default:
            break
        }
    }
    
    func request(_ request: WSAPIRequest, didSuceedWithData data: Any?) {
        switch request.endPoint.type {
        case .MarkThreadRead:
            guard let readState = request.data as? WSMessageThreadReadState else { return }
            let predicate = NSPredicate(format: "p_thread_id == %d", readState.threadID)
            if let messageThread = try! store.retrieve(WSMOMessageThread.self, sortBy: nil, isAscending: true, predicate: predicate, context: store.managedObjectContext).first {
                messageThread.is_new = !readState.read
                try! store.managedObjectContext.save()
            }
        case .UserInfo:
            guard
                let user = data as? WSUser,
                let url = user.profileImageURL
                else { return }
            let predicate = NSPredicate(format: "p_uid == %d", user.uid)
            if let user = try? store.retrieve(WSMOUser.self, sortBy: nil, isAscending: true, predicate: predicate, context: store.managedObjectContext).first {
                user?.image_url = url
                do {
                    try store.managedObjectContext.save()
                    api.contactEndPoint(.ImageResource, withPathParameters: url as NSString, andData: nil, thenNotify: self)
                } catch {
                    // Not a big deal. The author profile image won't be downloaded.
                }
            }
        case .ImageResource:
            guard
                let image = data as? UIImage,
                let url = request.parameters as? String
                else { return }
            setImage(image, forHostWithImageURL: url)
        default:
            break
        }
    }
    
    func request(_ request: WSAPIRequest, didFailWithError error: Error) {
        //
    }
    
}
