//
//  WSLocationSearchViewControllerProtocol.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import MapKit

protocol WSLocationSearchViewControllerProtocol {
    
    var mapView: MKMapView! { get set }
    var delegate: WSHostSearchControllerDelegate? { get set }
    
    /** Initiates a host search by location with the current region shown in the map view */
    func updateSearchResults()
}