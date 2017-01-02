//
//  DataSourceDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 2/01/17.
//  Copyright © 2017 Rajan Fernandez. All rights reserved.
//

import Foundation

public protocol DataSourceDelegate: class {
    
    // Called when a data begins an update.
    func dataSourceDidBeginLoading(_ dataSource: DataSource)
    
    // Called after a successful update.
    func dataSourceDidUpdate(_ dataSource: DataSource)
    
    // Called if an error occurs during an update.
    func dataSource(_ dataSource: DataSource, didUpdateWithError error: Error)
    
}
