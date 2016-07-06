//
//  WSMessageThreadTableViewController+NSFetchedResultsControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 4/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

extension WSMessageThreadTableViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async { () -> Void in
            self.tableView.beginUpdates()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        DispatchQueue.main.async { () -> Void in
            switch type {
            case .insert:
                self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            case .move:
                break
            case .update:
                break
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: AnyObject, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        DispatchQueue.main.async { () -> Void in
            switch type {
            case .insert:
                self.tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                self.tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                if let cell = self.tableView.cellForRow(at: indexPath!) {
                    self.configureCell(cell, indexPath: indexPath!)
                }
            case .move:
                self.tableView.deleteRows(at: [indexPath!], with: .fade)
                self.tableView.insertRows(at: [indexPath!], with: .fade)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async { () -> Void in
            self.tableView.endUpdates()
        }
    }
}
