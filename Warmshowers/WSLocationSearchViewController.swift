//
//  WSLocationSearchViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit
import CCHMapClusterController

class WSLocationSearchViewController : UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var statusLabel: UILabel!
    
    var clusterController: CCHMapClusterController!
    
    var mapOverlay: MKTileOverlay?
    var mapSource: WSMapSource = WSMapSource.appleMaps
    
    // MARK: Constants
    
    let locationManager = CLLocationManager()
    let kDefaultRegionLatitudeDelta: CLLocationDegrees = 1
    let kDefaultRegionLongitudeDelta: CLLocationDegrees = 1
    
    // This is the zoom level at which api request will be made
    let TileUpdateZoomLevel: UInt = 5
    
    // The level of dimming for tiles that are updating. A value between 0 and 1.
    let dimLevel: CGFloat = 0.3
    
//    // This is the minimum zoom level at which tiles should be updated.
//    let MinimumZoomLevelForTileUpdates: UInt = 5
//    
//    // This is the minimum zoom level that annotation will be shown
//    let MinimumZoomLevelToShowAnnotations: UInt = 2
    
    // Delegates
    var alertDelegate: WSAlertDelegate = WSAlertDelegate.sharedAlertDelegate
    var apiCommunicator: WSAPICommunicator = WSAPICommunicator.sharedAPICommunicator
    var store: WSStoreMapTileProtocol = WSStore.sharedStore
    
    override func viewDidLoad() {
        clusterController = CCHMapClusterController(mapView: mapView)
        clusterController.delegate = self
        configureToolbar()
        statusLabel.text = nil
        
        // Ask the users permission to use location services
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.showsUserLocation = true
        centreOnRegion()
    }
    
    func configureToolbar() {
        // This fix removes a shadow line from the top of the toolbar.
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
    }
    
    // MARK: Utility methods
    
    func centreOnRegion() {
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: kDefaultRegionLatitudeDelta, longitudeDelta: kDefaultRegionLongitudeDelta))
            DispatchQueue.main.async(execute: { [weak self] in
                self?.mapView.setRegion(region, animated: true)
                })
        }
    }
    
    func addUsersToMap(_ users: [WSUserLocation]?) {
        
        guard let users = users else { return }
        
        DispatchQueue.main.async(execute: { [weak self] in
            self?.clusterController.addAnnotations(users, withCompletionHandler: nil)
            })
        
//        mapView.performSelectorOnMainThread(#selector(MKMapView.addAnnotations(_:)), withObject: users, waitUntilDone: false)
    }
    
    func clearAnnotationsNotOnTiles(_ tiles: [WSMapTile]) {
        
        let quadKeys = tiles.map { (tile) -> String in return tile.quadKey }
        let unrequiredAnnotations = mapView.annotations.filter { (annotation) -> Bool in
            if annotation is WSUserLocation {
                if let tileID = (annotation as! WSUserLocation).tileID {
                    return !quadKeys.contains(tileID)
                }
            }
            return false
        }
        
        print("\(unrequiredAnnotations.count) / \(mapView.annotations.count) being removed from the map.")
        
        if unrequiredAnnotations.count > 0 {
            DispatchQueue.main.async(execute: { [weak self] in
                self?.clusterController.removeAnnotations(unrequiredAnnotations, withCompletionHandler: nil)
                })
            
//            mapView.performSelectorOnMainThread(#selector(MKMapView.removeAnnotations(_:)), withObject: unrequiredAnnotations, waitUntilDone: false)
        }
        
        print("\(mapView.annotations.count) remaining.")
    }
    
    func dimTile(_ tile: WSMapTile) {
        
        let polygon = tile.polygon()
        polygon.title = tile.quadKey
        
        mapView.performSelectorOnMainThread(#selector(MKMapView.addOverlay(_:)), withObject: polygon, waitUntilDone: false)
    }
    
    func undimTile(_ tile: WSMapTile) {
        
        let overlay = mapView.overlays.filter { (overlay) -> Bool in
            return overlay.title ?? "" ?? "" == tile.quadKey
        }.first
        
        if overlay != nil {
            mapView.performSelectorOnMainThread(#selector(MKMapView.removeOverlay(_:)), withObject: overlay!, waitUntilDone: true)
        }
    }

}
