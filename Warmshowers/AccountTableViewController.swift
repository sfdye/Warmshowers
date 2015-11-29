//
//  AccountTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 24/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit

let LOGOUT_CELL_ID = "Logout"

class AccountTableViewController: UITableViewController, WSRequestAlert {
    
    var user: WSUser?
    
    let httpClient = WSRequest()
    
    weak var appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    
    var alertController: UIAlertController?

    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        httpClient.alertViewController = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LOGOUT_CELL_ID, forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        
        if cell?.reuseIdentifier == LOGOUT_CELL_ID {
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            httpClient.logout({ (success) -> Void in
                if success {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        defaults.setObject(nil, forKey: PASSWORD)
                        defaults.setObject(nil, forKey: SESSION_COOKIE)
                        self.appDelegate?.showLoginScreen()
                    })
                }
            })
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - WSRequestAlert Delegate functions
    
    func requestAlert(title: String, message: String) {
        
        guard alertController == nil else {
            return
        }
        
        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        if alertController != nil {
            alertController!.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController!, animated: true, completion: { () -> Void in self.alertController = nil})
        }
    }

}
