//
//  WSFeedbackTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 12/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSFeedbackTableViewController: WSAPIResponseDelegate {
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        switch request.endPoint.type {
        case .UserInfo:
            if data is WSUser {
                if let uidString = request.parameters as? String, let uid = Int(uidString) {
                    // Set the authors profile image URL as the URL or an empty string so that the download is not retried.
                    let url = (data as! WSUser).profileImageURL ?? ""
                    setAuthorImageURL(url, forHostWithUID: uid)
                    // Download the authors profile image.
                    api.contactEndPoint(.ImageResource, withPathParameters: url as NSString, andData: nil, thenNotify: self)
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
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        // No need for action
    }
    
}