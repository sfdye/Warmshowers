//
//  WSAccountTableViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSAccountTableViewController {
    
    @IBAction func actionButtonPressed(_ sender: AnyObject) {
        guard let uid = session.uid, let actionAlert = actionAlertForUserWithUID(uid) else { return }
        present(actionAlert, animated: true, completion: nil)
    }
    
}
