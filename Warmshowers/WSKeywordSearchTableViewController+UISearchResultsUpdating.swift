//
//  WSKeywordSearchTableViewController+UISearchResultsUpdating.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSKeywordSearchTableViewController : UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        updateSearchResultsForKeyword(searchController.searchBar.text)
    }
}