//
//  HostsViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

// TODOs
// address this issue (add gps routes to the map)
// https://ro.warmshowers.org/node/112508
// - make the pin clustering like the website and android app

// add loading indicator to map view


enum MapSource {
    case AppleMaps
    case OpenCycleMaps
    case OpenStreetMaps
}

class HostMapViewController: UIViewController, MKMapViewDelegate, WSRequestAlert, CLLocationManagerDelegate {
    
    // MARK: Properties
    
    @IBOutlet var mapView: MKMapView!
    
    let httpClient = WSRequest()
    let locationManager = CLLocationManager()
    
    // map source variables
    var mapSource = MapSource.AppleMaps
    var mapOverlay: MKTileOverlay? = nil
    var overlay: MKTileOverlay? = nil
    
    // host data variables
    var hosts = [WSUserLocation]()
    
    // pin clustering controller
    private var clusteringController : KPClusteringController!
    
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // allows the http client to diplay alerts through this view controller
        httpClient.alertViewController = self
        
        // ask the users permission to use location services
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.showsUserLocation = true
        
        // pin clustering
        let algorithm : KPGridClusteringAlgorithm = KPGridClusteringAlgorithm()
        algorithm.annotationSize = CGSizeMake(25, 50)
        algorithm.clusteringStrategy = KPGridClusteringAlgorithmStrategy.TwoPhase;
        clusteringController = KPClusteringController(mapView: self.mapView, clusteringAlgorithm: algorithm)
        clusteringController.delegate = self
        clusteringController.setAnnotations(hosts)
        
        updateHostsOnMap()
        
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
                    self.updateHostList(data!)
                })
            }
        }
    }
    
    // Adds hosts to the map with data from the web
    func updateHostList(data: NSData) {
        
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
        
        // update the cluster controller on the main thread (otherwise it complains)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.updateClusteringController()
        })
    }
    
    // Updates the pin clustering controller
    func updateClusteringController() {
        if self.hosts.count != 0 {
            clusteringController.setAnnotations(hosts)
            clusteringController.refresh(true)
        }
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
        
        if annotation is MKUserLocation {
            // return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        var annotationView : MKPinAnnotationView?
        
        if annotation is KPAnnotation {
            let a = annotation as! KPAnnotation
            
            if a.isCluster() {
                annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("cluster") as? MKPinAnnotationView
                
                if (annotationView == nil) {
                    annotationView = MKPinAnnotationView(annotation: a, reuseIdentifier: "cluster")
                }
                
                annotationView!.pinTintColor = UIColor.purpleColor()
            }
                
            else {
                annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
                
                if (annotationView == nil) {
                    annotationView = MKPinAnnotationView(annotation: a, reuseIdentifier: "pin")
                }
                
                annotationView!.pinTintColor = UIColor.redColor()
            }
            
            annotationView!.canShowCallout = true;
        }
        
        return annotationView;
        
    }
    
    // Moves the map to users location
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let userLocation = (locationManager.location?.coordinate)!
        mapView.setCenterCoordinate(userLocation , animated: true)
    }
    
    // Called when a pin is selected
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if view.annotation is KPAnnotation {
            let cluster = view.annotation as! KPAnnotation
            
            if cluster.annotations.count > 1 {
                let region = MKCoordinateRegionMakeWithDistance(cluster.coordinate,
                    cluster.radius * 2.5,
                    cluster.radius * 2.5)
                
                mapView.setRegion(region, animated: true)
            }
        }
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
        
        if self.presentationController != nil {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    
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

// MARK: <CLControllerDelegate>

extension HostMapViewController : KPClusteringControllerDelegate {
    func clusteringControllerShouldClusterAnnotations(clusteringController: KPClusteringController!) -> Bool {
        return true
    }
}
