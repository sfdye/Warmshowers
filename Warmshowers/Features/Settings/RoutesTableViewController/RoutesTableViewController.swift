//
//  RoutesTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 6/09/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

let RUID_FileCell = "FileCell"

class RoutesTableViewController: UITableViewController {
    
    var files = [String]()

    override func viewDidLoad() {
        
        guard
            let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
            let documents = try? FileManager.default.contentsOfDirectory(atPath: documentsDirectory)
            else {
            return
        }
        
        for file in documents {
            if file.contains(".kml") || file.contains(".gps") {
                files.append(file)
            }
        }
        
        DispatchQueue.main.async { 
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RUID_FileCell, for: indexPath)
        cell.textLabel?.text = files[(indexPath as NSIndexPath).row]
        return cell
    }
    
}
