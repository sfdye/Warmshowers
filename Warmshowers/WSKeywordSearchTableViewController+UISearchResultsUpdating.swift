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
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        // Cancel any searches about to be fired
        if debounceTimer != nil {
            debounceTimer!.invalidate()
        }
        
        // Display a blank table if there is nothing in the search bar
        guard let keyword = searchController.searchBar.text where keyword != "" else {
            clearTable()
            debounceTimer = nil
            return
        }
        
        // Search after 0.5 seconds to debounce input
        debounceTimer = NSTimer(timeInterval: 0.7, target: self, selector: #selector(WSKeywordSearchTableViewController.searchWithKeywordOnTimer(_:)), userInfo: keyword, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(debounceTimer!, forMode: "NSDefaultRunLoopMode")
        
        // Clear out old search results
        clearTable()
    }
}