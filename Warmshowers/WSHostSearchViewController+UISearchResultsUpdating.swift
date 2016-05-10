//
//  WSHostSearchViewController+UI.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostSearchViewController : UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        (self.childViewControllers.last as? WSKeywordSearchTableViewControllerProtocol)?.updateSearchResultsForKeyword(searchController.searchBar.text)
    }
}