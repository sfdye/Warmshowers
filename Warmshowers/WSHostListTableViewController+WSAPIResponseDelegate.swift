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
        guard
            let imageURL = request.parameters as? String,
            let image = data as? UIImage
            else { return }
        setImage(image, forHostWithImageURL: imageURL)
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        // No need for action.
    }
}