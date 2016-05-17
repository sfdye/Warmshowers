//
//  WSKeywordSearchTableViewController+UIScrollViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSKeywordSearchTableViewController {
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForObjectsOnScreen()
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        loadImagesForObjectsOnScreen()
    }
}