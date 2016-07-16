//
//  WSLocationSearchViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

extension WSLocationSearchViewController {
    
    /** Centres the map on the users location. */
    @IBAction func centerOnUserLocation(sender:AnyObject?) {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            dispatch_async(dispatch_get_main_queue(), { [unowned self] in
                self.mapView.setCenterCoordinate(self.mapView.userLocation.coordinate, animated: true)
                })
        } else {
            let alert = UIAlertController(title: "Enable location services", message: "To centre the map on your location we need to know your location. Please change your location access settings.", preferredStyle: .Alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .Default, handler: { (action) in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) where UIApplication.sharedApplication().canOpenURL(url) {
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            alert.addAction(settingsAction)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(okAction)
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                self?.presentViewController(alert, animated: true, completion: nil)
                })
        }
    }
}