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
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            self?.tableView.beginUpdates()
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            switch type {
            case .Insert:
                self?.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                self?.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Update:
                guard let message = anObject as? CDWSMessage else { return }
                if var cell = self?.tableView.cellForRowAtIndexPath(indexPath!) as? MessageTableViewCell {
                    self?.configureCell(&cell, withMessage: message)
                }
            case .Move:
                self?.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                self?.tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            }
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            self?.tableView.endUpdates()
        }
    }
}
