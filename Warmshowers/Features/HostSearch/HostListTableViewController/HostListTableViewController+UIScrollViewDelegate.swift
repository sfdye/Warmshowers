//
//  HostListTableViewController+UIScrollViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 6/08/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension HostListTableViewController {
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForObjectsOnScreen()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForObjectsOnScreen()
    }
    
}
