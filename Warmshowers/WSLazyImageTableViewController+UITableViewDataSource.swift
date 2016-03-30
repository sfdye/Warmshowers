//
//  WSLazyImageTableViewController+UITableViewDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSLazyImageTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.numberOfRowsInSection != nil {
            return dataSource.numberOfRowsInSection!(section)
        } else {
            return lazyImageObjects.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = dataSource.lazyImageCellForIndexPath(indexPath)
        setLazyImageForCell(cell, atIndexPath: indexPath)
        return cell
    }
}