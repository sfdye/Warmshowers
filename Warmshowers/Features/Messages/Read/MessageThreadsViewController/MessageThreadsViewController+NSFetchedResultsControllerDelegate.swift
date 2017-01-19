//
//  MessageThreadsViewController+UIFetchedResultsControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData
import WarmshowersData

extension MessageThreadsViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            guard
                let messageThread = anObject as? MOMessageThread,
                let indexPath = indexPath,
                let cell = tableView.cellForRow(at: indexPath) as? MessageThreadsTableViewCell
            else { return }
            configureCell(cell, withMessageThread: messageThread)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [indexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        DispatchQueue.main.async { [weak self] in
            self?.updateTabBarBadge()
        }
    }
    
}
