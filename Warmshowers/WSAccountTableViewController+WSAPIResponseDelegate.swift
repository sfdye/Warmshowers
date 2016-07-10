//
//  WSAccountTableViewController+WSAPIResponseDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSAccountTableViewController: WSAPIResponseDelegate {
    
    func request(request: WSAPIRequest, didSuceedWithData data: AnyObject?) {
        switch request.endPoint.type {
        case .ImageResource:
            guard let image = data as? UIImage else { return }
            user?.profileImage = image
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                self?.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })
        case .UserFeedback:
            guard let feedback = data as? [WSRecommendation] else { return }
            user?.feedback = feedback
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                let indexPath = NSIndexPath(forRow: 0, inSection: 2)
                self?.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                })
        default:
            break
        }
    }
    
    func request(request: WSAPIRequest, didFailWithError error: ErrorType) {
        // No need to action.
        print(error)
    }
    
}