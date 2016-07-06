//
//  WSMessageThreadsTableViewController+UIFetchedResultsControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

extension WSMessageThreadsTableViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
        self.updateTabBarBadge()
    }
    
//    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
//            switch type {
//            case .Insert:
//                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
//            case .Delete:
//                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
//            case .Move:
//                break
//            case .Update:
//                break
//        }
//    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: AnyObject, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            switch type {
            case .insert:
                print("insert")
                self.tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                print("delete")
                self.tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                print("update")
                if let cell = self.tableView.cellForRow(at: indexPath!) {
                    self.configureCell(cell, indexPath: indexPath!)
                }
            case .move:
                self.tableView.deleteRows(at: [indexPath!], with: .fade)
                self.tableView.insertRows(at: [indexPath!], with: .fade)
            }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            self.tableView.endUpdates()
    }
    
}
