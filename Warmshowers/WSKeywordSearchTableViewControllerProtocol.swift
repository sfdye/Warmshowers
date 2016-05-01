//
//  WSKeywordSearchTableViewControllerProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

protocol WSKeywordSearchTableViewControllerProtocol {
    
    var tableView: UITableView! { get set }
    var delegate: WSHostSearchControllerDelegate? { get set }
    
    /** Initiates a search for hosts by keyword and updated the table view with the results */
    func updateSearchResultsForKeyword(keyword: String?)
}