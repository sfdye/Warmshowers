//
//  WSHostSearchViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostSearchViewController {
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        showTableView()
        present(searchController, animated: true, completion: { [weak self] () -> Void in
            self?.searchController.isActive = true
            })
//
//        didPresentSearchController(searchController)
    }
    
    @IBAction func accountButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: SID_MapToUserAccount, sender: nil)
    }
}
