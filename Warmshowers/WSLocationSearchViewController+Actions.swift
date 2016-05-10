//
//  WSLocationSearchViewController+Actions.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 10/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSLocationSearchViewController {
    
    @IBAction func centreOnLocation() {
        if let coordinate = locationManager.location?.coordinate {
            mapView.setCenterCoordinate(coordinate, animated: true)
        }
    }
}