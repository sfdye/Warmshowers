//
//  HostsViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// TODOs
// address this issue
// https://ro.warmshowers.org/node/112508

// add loading indicator to map view


enum MapSource {
    case AppleMaps
    case OpenCycleMaps
    case OpenStreetMaps
}

class HostMapViewController: UIViewController, MKMapViewDelegate, WSRequestAlert, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    let httpClient = WSRequest()
    let locationManager = CLLocationManager()
    
    // map source variables
    var mapSource = MapSource.AppleMaps
    var mapOverlay: MKTileOverlay? = nil
    var overlay: MKTileOverlay? = nil
    
    // host data variables
    var hosts = [WSUserLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // allows the http client to diplay alerts through this view controller
        httpClient.alertViewController = self
        
//        // Ask for Authorisation from the User.
//        self.locationManager.requestAlwaysAuthorization()
//        
//        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
//        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
        
        // update the map
        let auth = CLLocationManager.authorizationStatus()
        print(auth.rawValue)
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            print("here")
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.showsUserLocation = true
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Checks if a user is already in the map data source
    func userOnMap(uid: Int) -> Bool {
        
        for host in hosts {
            if host.uid == uid {
                return true
            }
        }
        return false
    }
    
    // Updates the hosts shown on the map
    func updateHostsOnMap() {
        
        httpClient.getHostDataForMapView(mapView) { (data) -> Void in
            
            // update the mapView data source
            if data != nil {
                let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                
                dispatch_async(queue, { () -> Void in
                    self.addHostsToMap(data!)
                    
                })
            }
        }
    }
    
    // Adds hosts to the map with data from the web
    func addHostsToMap(data: NSData) {
        
        // parse the json
        if let json = self.httpClient.jsonDataToDictionary(data) {
            if let accounts = json["accounts"] as? NSArray {
                for account in accounts {
                    if let user = WSUserLocation.initWithObject(account) {
                        if !self.userOnMap(user.uid!) {
                            self.hosts.append(user)
                        }
                    }
                }
            }
        }
        
        // add the hosts to the map
        mapView.addAnnotations(hosts)
        
    }
    
    
    // MARK: - Map source functions
    
    // changes the map source
    func switchToMapSource(source: MapSource) {
        self.mapSource = source
        setMapOverlay()
    }
    
    // Returns an overlay for the current map source
    func selectMapOverlay() -> MKTileOverlay? {
        
        switch mapSource {
        case .OpenCycleMaps:
            return MKTileOverlay.init(URLTemplate: MapTileServerURLTemplate.OpenCycleMaps())
        case .OpenStreetMaps:
            return MKTileOverlay.init(URLTemplate: MapTileServerURLTemplate.OpenStreetMaps())
        default:
            return nil
        }
        
    }
    
    // Sets the overlay variable to the current map source and update the mapView overlays
    func setMapOverlay() {
        
        // remove the existing overlay object from the mapView
        if mapOverlay != nil {
            mapView.removeOverlay(mapOverlay!)
        }
        
        // set a new map overlay
        if let overlay = selectMapOverlay() {
            overlay.canReplaceMapContent = true;
            mapOverlay = overlay
        } else {
            mapOverlay = nil
        }
        
        // add the new map
        if mapOverlay != nil {
            mapView.addOverlay(mapOverlay!, level: MKOverlayLevel.AboveLabels)
        }
        
    }
    
    // MARK: - MKMapViewDelegate methods
    
    // Used to display tiles for maps other than Apple Maps
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if mapOverlay != nil {
            return MKTileOverlayRenderer.init(overlay: overlay)
        } else {
            return MKTileOverlayRenderer.init();
        }
    }
    
    // Called for every annotation
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? WSUserLocation {
            
            let identifier = "pin"
            
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    // Moves the map to users location
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let userLocation = (locationManager.location?.coordinate)!
        mapView.setCenterCoordinate(userLocation , animated: true)
    }
    
    // Called when the details button on an annotation is pressed
//    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
//        calloutAccessoryControlTapped control: UIControl) {
//            let location = view.annotation as! Artwork
//            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//            // convert the location to a MKMapItem object and pass it to the maps app
//            location.mapItem().openInMapsWithLaunchOptions(launchOptions)
//    }
    
    // Called when the map view changes
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateHostsOnMap()
    }
    
    // MARK: - CLLocationMangerDelegate functions
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    
    // MARK: - WSRequestAlert Delegate functions
    
    func requestAlert(title: String, message: String) {
        
//        if self.presentationController != nil {
//            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alertController, animated: true, completion: nil)
//        }
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
