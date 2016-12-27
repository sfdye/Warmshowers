//
//  KeywordSearchTableViewController+APIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import WarmshowersData

extension KeywordSearchTableViewController : APIResponseDelegate {
    
    func request(_ request: APIRequest, didSucceedWithData data: Any?) {
        switch request.endPointType {
        case .searchByKeyword:
            reloadTableWithHosts(data as? [UserLocation])
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
        reloadTableWithHosts([UserLocation]())
    }
}
