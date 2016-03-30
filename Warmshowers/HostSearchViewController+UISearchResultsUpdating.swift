//
//  HostSearchViewController+UI.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

extension HostSearchViewController : UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        // Cancel any searches about to be fired
        if debounceTimer != nil {
            debounceTimer!.invalidate()
        }
        
        // Display a blank table if there is nothing in the search bar
        guard let keyword = searchController.searchBar.text where keyword != "" else {
            tableViewController.clearTable()
            debounceTimer = nil
            return
        }
        
        // Search after 0.5 seconds to debounce input
        debounceTimer = NSTimer(timeInterval: 0.5, target: self, selector: Selector("updateSearchResultsWithKeyword"), userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(debounceTimer!, forMode: "NSDefaultRunLoopMode")
        
        // Clear out old search results
        tableViewController.clearTable()
    }
    
}