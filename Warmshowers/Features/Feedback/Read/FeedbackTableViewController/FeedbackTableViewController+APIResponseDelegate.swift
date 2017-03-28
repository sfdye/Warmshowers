//
//  FeedbackTableViewController+APIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 12/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import WarmshowersData

extension FeedbackTableViewController: APIResponseDelegate {
    
    func request(_ request: APIRequest, didSucceedWithData data: Any?) {
        switch request.endPointType {
        case .user:
            if data is User {
                if let uid = request.parameters as? Int {
                    // Set the authors profile image URL as the URL or an empty string so that the download is not retried.
                    let url = (data as! User).profileImageURL ?? ""
                    setAuthorImageURL(url, forHostWithUID: uid)
                    // Download the authors profile image.
                    api.contact(endPoint: .imageResource, withMethod: .get, andPathParameters: url, andData: nil, thenNotify: self, ignoreCache: false)
                }
            }
        case .imageResource:
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
