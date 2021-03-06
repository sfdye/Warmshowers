//
//  FeedbackTableViewController+UIScrollViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 12/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension FeedbackTableViewController {
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForObjectsOnScreen()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForObjectsOnScreen()
    }
    
}
