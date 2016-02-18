//
//  HostSearchViewController+CLLocationManagerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation
import kingpin

extension HostSearchViewController : MKMapViewDelegate {
    
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
        if let a = annotation as? KPAnnotation {
            if a.isCluster() {
                
                // Clustered host map pins
                if let dequeueView = mapView.dequeueReusableAnnotationViewWithIdentifier("cluster") as? MKPinAnnotationView {
                    annotationView = dequeueView
                } else {
                    annotationView = MKPinAnnotationView(annotation: a, reuseIdentifier: "cluster")
                }
                
                // Purple pins for clusters
                annotationView!.pinTintColor = UIColor.purpleColor()
            }
                
            else {
                
                // Single host map pins
                if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView {
                    annotationView = dequeuedView
                } else {
                    annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                }
                
                // Red pins for single hosts
                annotationView!.pinTintColor = UIColor.redColor()
            }
            
            // Add an accessory button to the annotation
            let button = UIButton(type: UIButtonType.DetailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
            
            annotationView!.canShowCallout = true;
        }
        
        return annotationView;
    }
    
//    // Moves the map to users location
//    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
//        let userLocation = (locationManager.location?.coordinate)!
//        mapView.setCenterCoordinate(userLocation , animated: true)
//    }
    
//    // Called when a pin is selected
//    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
//        if view.annotation is KPAnnotation {
////            let cluster = view.annotation as! KPAnnotation
//            
//            // zooms to location
////            if cluster.annotations.count > 1 {
////                let region = MKCoordinateRegionMakeWithDistance(cluster.coordinate,
////                    cluster.radius * 2.5,
////                    cluster.radius * 2.5)
////                
////                mapView.setRegion(region, animated: true)
////            }
////        }
//    }
    
    // Called when the details button on an annotation is pressed
    //
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
            if let kpAnnotation = view.annotation as? KPAnnotation {
                if view.reuseIdentifier == "cluster" {
                    // Show a list of the clustered hosts
                    performSegueWithIdentifier(ToHostListSegueID, sender: kpAnnotation)
                } else {
                    // Show the host profile
                    performSegueWithIdentifier(MapToUserAccountSegueID, sender: kpAnnotation)
                }
            }
    }
    
    // Called when the map view changes
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateHostsOnMap()
    }
        
}