//
//  FeedbackTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 12/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension FeedbackTableViewController: APIResponseDelegate {
    
    func request(_ request: APIRequest, didSuceedWithData data: Any?) {
        switch request.endPoint.type {
        case .UserInfo:
            if data is User {
                if let uidString = request.parameters as? String, let uid = Int(uidString) {
                    // Set the authors profile image URL as the URL or an empty string so that the download is not retried.
                    let url = (data as! User).profileImageURL ?? ""
                    setAuthorImageURL(url, forHostWithUID: uid)
                    // Download the authors profile image.
                    api.contact(endPoint: .ImageResource, withPathParameters: url as NSString, andData: nil, thenNotify: self)
                }
            }
        case .ImageResource:
            guard
                let imageURL = request.parameters as? String,
                let image = data as? UIImage
                else { return }
            setImage(image, forHostWithImageURL: imageURL)
        default:
            break
        }
    }
    
    func request(_ request: APIRequest, didFailWithError error: Error) {
        // No need for action
    }
    
}
