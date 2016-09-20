//
//  WSKeywordSearchTableViewController+WSKeywordSearchTableViewControllerProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSKeywordSearchTableViewController : UISearchResultsUpdating {
    
    /** Updates the hosts to be shown in the table view. Not this method is debounced and so will not run with a frquency greater than 2 Hz */
    func updateSearchResults(for searchController: UISearchController) {
        
        // Cancel any searches about to be fired
        if debounceTimer != nil {
            debounceTimer!.invalidate()
        }
        
        // Display a blank table if there is nothing in the search bar
        guard let keyword = searchController.searchBar.text , keyword != "" else {
            clearTable()
            debounceTimer = nil
            return
        }
        
        // Search after 0.5 seconds to debounce input
        debounceTimer = Timer(timeInterval: 0.7, target: self, selector: #selector(WSKeywordSearchTableViewController.searchWithKeywordOnTimer(_:)), userInfo: keyword, repeats: false)
        RunLoop.current.add(debounceTimer!, forMode: RunLoopMode.defaultRunLoopMode)
        
        // Show the spinner
        showSpinner()
    }
}
