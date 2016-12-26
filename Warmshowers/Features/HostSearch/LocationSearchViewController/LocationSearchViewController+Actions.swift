//
//  LocationSearchViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

extension LocationSearchViewController {
    
    /** Centres the map on the users location. */
    @IBAction func centerOnUserLocation(_ sender:AnyObject?) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            DispatchQueue.main.async(execute: { [unowned self] in
                self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
                })
        } else {
            let alert = UIAlertController(title: "Enable location services", message: "To centre the map on your location we need to know your location. Please change your location access settings.", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { (action) in
                if let url = URL(string: UIApplicationOpenSettingsURLString) , UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [String : Any](), completionHandler: nil)
                }
            })
            alert.addAction(settingsAction)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            DispatchQueue.main.async(execute: { [weak self] in
                self?.present(alert, animated: true, completion: nil)
                })
        }
    }
}
