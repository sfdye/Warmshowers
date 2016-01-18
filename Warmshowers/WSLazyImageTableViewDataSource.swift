//
//  WSLazyImageTableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

@objc protocol WSLazyImageTableViewDataSource {
    optional func numberOfRowsInSection(section: Int) -> Int
    func lazyImageCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell
}