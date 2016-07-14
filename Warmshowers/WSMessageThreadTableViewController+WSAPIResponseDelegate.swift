//
//  WSMessageThreadTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSMessageThreadTableViewController: WSAPIResponseDelegate {
    
    func requestDidComplete(request: WSAPIRequest) {
        switch request.endPoint.type {
        case .GetMessageThread:
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                self?.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            })
        case .UserInfo:
            guard let uid = request.parameters as? String else { return }
            downloadsInProgress.insert(uid)
        default:
            break
        }
    }
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        switch request.endPoint.type {
        case .MarkThreadRead:
            guard let readState = request.data as? WSMessageThreadReadState else { return }
            let _ = try? store.markMessageThread(readState.threadID, read: readState.read)
        case .UserInfo:
            guard
                let user = data as? WSUser,
                let url = user.profileImageURL
                else { return }
            api.contactEndPoint(.ImageResource, withPathParameters: url as NSString, andData: nil, thenNotify: self)
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
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        //
    }
    
}