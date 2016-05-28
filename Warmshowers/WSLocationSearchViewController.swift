//
//  WSLocationSearchViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

class WSLocationSearchViewController : UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var statusLabel: UILabel!
    
    var mapOverlay: MKTileOverlay?
    var mapSource: WSMapSource = WSMapSource.AppleMaps
    
    // MARK: Constants
    
    let locationManager = CLLocationManager()
    let kDefaultRegionLatitudeDelta: CLLocationDegrees = 1
    let kDefaultRegionLongitudeDelta: CLLocationDegrees = 1
    
    // Delegates
    var alertDelegate: WSAlertDelegate = WSAlertDelegate.sharedAlertDelegate
    var apiCommunicator: WSAPICommunicator = WSAPICommunicator.sharedAPICommunicator
    var store: WSStoreMapTileProtocol = WSStore.sharedStore
    
    override func viewDidLoad() {
        configureToolbar()
        statusLabel.text = nil
        
        // Ask the users permission to use location services
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.showsUserLocation = true
        centreOnRegion()
    }
    
    func configureToolbar() {
        // This fix removes a shadow line from the top of the toolbar.
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .Any, barMetrics: .Default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .Any)
    }
    
    // MARK: Utility methods
    
    func centreOnRegion() {
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: kDefaultRegionLatitudeDelta, longitudeDelta: kDefaultRegionLongitudeDelta))
            mapView.setRegion(region, animated: true)
        }
    }
    
    func addUsersToMap(users: [WSUserLocation]?) {
        print("adding to map")
    }
    
    func addOverlayForMapTile(tile: WSMapTile) {
        print("adding overlay")
    }
}
