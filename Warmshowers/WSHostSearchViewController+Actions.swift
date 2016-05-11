//
//  WSHostSearchViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostSearchViewController {
    
    @IBAction func searchButtonPressed(sender: UIBarButtonItem) {
        showTableView()
        presentViewController(searchController, animated: true, completion: nil)
        searchController.active = true
        didPresentSearchController(searchController)
    }
    
    @IBAction func accountButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier(MapToUserAccountSegueID, sender: nil)
    }
}