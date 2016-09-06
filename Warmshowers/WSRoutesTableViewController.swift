//
//  WSRoutesTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 6/09/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

let RUID_FileCell = "FileCell"

class WSRoutesTableViewController: UITableViewController {
    
    var files = [String]()

    override func viewDidLoad() {
        
        guard
            let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first,
            let documents = try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(documentsDirectory)
            else {
            return
        }
        
        for file in documents {
            if file.containsString(".kml") || file.containsString(".gps") {
                files.append(file)
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) { 
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(RUID_FileCell, forIndexPath: indexPath)
        cell.textLabel?.text = files[indexPath.row]
        return cell
    }
    
}
