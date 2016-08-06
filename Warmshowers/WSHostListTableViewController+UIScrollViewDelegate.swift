//
//  WSHostListTableViewController+UIScrollViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 6/08/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostListTableViewController {
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForObjectsOnScreen()
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        loadImagesForObjectsOnScreen()
    }
    
}