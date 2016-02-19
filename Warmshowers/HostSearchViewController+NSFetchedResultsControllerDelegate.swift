//
//  HostSearchViewController+NSFetchedResultsControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CoreData

extension HostSearchViewController : NSFetchedResultsControllerDelegate {
    
    // MARK: Delegate methods
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        print("object changed")
        print(anObject)
        switch type {
        case .Insert:
            mapView.addAnnotation(anObject as! CDWSUser)
        case .Delete:
            mapView.removeAnnotation(anObject as! CDWSUser)
        case .Update:
            mapView.addAnnotation(anObject as! CDWSUser)
            mapView.removeAnnotation(anObject as! CDWSUser)
        case .Move:
            // Do nothing. The order of the annotation on the map is irrelevant.
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        print("updated")
    }
    
}
