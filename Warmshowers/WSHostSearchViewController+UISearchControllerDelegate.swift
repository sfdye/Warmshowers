//
//  WSHostSearchViewController+UISearchControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostSearchViewController : UISearchControllerDelegate {
    
    func didPresent(_ searchController: UISearchController) {
        showTableView()
    }
    
    func didDismiss(_ searchController: UISearchController) {
        showMapView()
    }
}
