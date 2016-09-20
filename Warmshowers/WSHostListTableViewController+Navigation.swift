//
//  WSHostListTableViewController+Navigation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 11/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSHostListTableViewController {
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return sender is WSUser
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard sender is WSUser else { return }
        let accountTVC = segue.destination as! WSAccountTableViewController
        accountTVC.user = sender as? WSUser
    }
    
}
