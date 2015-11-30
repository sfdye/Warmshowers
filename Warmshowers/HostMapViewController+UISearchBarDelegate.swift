//
//  HostMapViewController+UISearchBar.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

extension HostMapViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {

        self.navigationItem.setRightBarButtonItem(cancelButton, animated: true)
        self.navigationItem.setLeftBarButtonItem(nil, animated: true)
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        self.navigationItem.setRightBarButtonItem(nil, animated: true)
        self.navigationItem.setLeftBarButtonItem(accountButton, animated: true)
        
    }
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // search request here
        
    }
    
}