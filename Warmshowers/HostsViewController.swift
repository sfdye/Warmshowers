//
//  HostsViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

class HostsViewController: UIViewController {
    
    // Segmented control
//    @IBOutlet weak var segmentedControl: UISegmentedControl!
    

    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Default to the map view
//        segmentedControlChange()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    // MARK: - Segmented control delegate
//    @IBAction func segmentedControlChange() {
//        
//        // Select the appropriate view
//        switch segmentedControl.selectedSegmentIndex {
//        case 0:
//            mapView.hidden = false
//            tableView.hidden = true
//        case 1:
//            mapView.hidden = true
//            tableView.hidden = false
//        case 2:
//            mapView.hidden = true
//            tableView.hidden = false
//        default:
//            segmentedControl.selectedSegmentIndex = 0
//            segmentedControlChange()
//        }
//    
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
