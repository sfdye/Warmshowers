//
//  FeedbackTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 3/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

let FEEDBACK_CELL_ID = "Feedback"

class FeedbackTableViewController: UITableViewController {
    
    let httpClient = WSRequest()
    
    var feedback: [WSRecommendation]?
    
    override func viewDidLoad() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }
    
    
    // MARK: - Tableview Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if feedback != nil {
            return feedback!.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(FEEDBACK_CELL_ID, forIndexPath: indexPath) as! FeedbackTableViewCell
        if feedback != nil {
            cell.configureWithFeedback(feedback![indexPath.row])
            if feedback![indexPath.row].authorImage == nil {
                self.getAuthorImageForFeedbackAtIndex(indexPath.row, whenDone: { () -> Void in
                    self.reloadRowAtIndexPath(indexPath)
                })
            }
        }
        
        return cell

    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        if cell?.reuseIdentifier == SEGMENT_CELL_ID {
//            tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        }
//    }
    
    
    // MARK: Utilities
    
    // Reloads the table view
    //
    func reload() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
        }
    }
    
    func reloadRowAtIndexPath(indexPath: NSIndexPath) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        })
    }
    
    // Parses JSON to set the table data source feedback array
    //
    func parseFeedbackJSON(json: AnyObject?) {
        
        guard let json = json else {
            return
        }
        
        print(json)
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) { () -> Void in
            if let allRecommendations = json.valueForKey("recommendations") as? NSArray {
                for recommendationObject in allRecommendations {
                    if let recommendationJSON = recommendationObject.valueForKey("recommendation") {
                        if let recommendation = WSRecommendation(json: recommendationJSON) {
                            if self.feedback == nil {
                                self.feedback = [recommendation]
                            } else {
                                self.feedback!.append(recommendation)
                            }
                        }
                    }
                }
            }
            self.reload()
        }
    }
    
    // Gets the author thumbnail for a given feedback object
    //
    func getAuthorImageForFeedbackAtIndex(index: Int, whenDone: () -> Void) {
        
        guard feedback != nil else {
            return
        }
        
        guard index < feedback!.count else {
            return
        }
        
        httpClient.getUserThumbnailImage(self.feedback![index].author.uid) { (image) -> Void in
            if image != nil {
                self.feedback![index].authorImage = image
            } else {
                print("Failed to get thumbnail for user \(self.feedback![index].author.fullname)")
            }
            whenDone()
        }
    }

}
