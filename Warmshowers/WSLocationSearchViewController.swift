//
//  WSLocationSearchViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

class WSLocationSearchViewController : NSObject {
    
    var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    var mapOverlay: MKTileOverlay?
    var mapSource: WSMapSource = WSMapSource.AppleMaps
    
    // Delegates
    var delegate: WSHostSearchControllerDelegate?
    var apiCommunicator: WSAPICommunicator? = WSAPICommunicator.sharedAPICommunicator
    
}
