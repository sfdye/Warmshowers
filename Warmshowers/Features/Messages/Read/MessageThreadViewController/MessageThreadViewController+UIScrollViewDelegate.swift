//
//  MessageThreadViewController+UIScrollViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 13/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension MessageThreadViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForObjectsOnScreen()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForObjectsOnScreen()
    }
    
}
