//
//  HostSearchViewController+UI.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

extension HostSearchViewController : UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        guard let keyword = searchController.searchBar.text where keyword != "" else {
            return
        }
        
        updateSearchResultsWithKeyword(keyword)
    }
    
}