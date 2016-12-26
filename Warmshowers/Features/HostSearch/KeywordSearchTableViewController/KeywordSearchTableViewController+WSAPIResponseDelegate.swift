//
//  KeywordSearchTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension KeywordSearchTableViewController : APIResponseDelegate {
    
    func request(_ request: APIRequest, didSuceedWithData data: Any?) {
        switch request.endPoint.type {
        case .SearchByKeyword:
            reloadTableWithHosts(data as? [WSUserLocation])
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
        reloadTableWithHosts([WSUserLocation]())
    }
}
