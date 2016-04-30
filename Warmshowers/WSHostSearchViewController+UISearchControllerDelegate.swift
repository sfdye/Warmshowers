//
//  WSHostSearchViewController+UISearchControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostSearchViewController : UISearchControllerDelegate {
    
    func didPresentSearchController(searchController: UISearchController) {
        showTableView()
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        showMapView()
    }
}