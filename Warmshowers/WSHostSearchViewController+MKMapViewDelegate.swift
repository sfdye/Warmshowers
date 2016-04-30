//
//  WSHostSearchViewController+MKMapViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CCHMapClusterController

extension WSHostSearchViewController : MKMapViewDelegate {
    
    // Used to display tiles for maps other than Apple Maps
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        if mapOverlay != nil {
            return MKTileOverlayRenderer.init(overlay: overlay)
        }
        
        // tile colouring overlay
        if overlay.isKindOfClass(MKPolygon) {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.strokeColor = UIColor.redColor()
            renderer.lineWidth = 2
            return renderer
        }
        
        // Defautlt overlay renderer
        return MKTileOverlayRenderer.init();
    }
    
    // Called for every annotation
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            // return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        var annotationView : MKPinAnnotationView?
        if let clusterAnnotation = annotation as? CCHMapClusterAnnotation {
            
            if clusterAnnotation.isCluster() {
                
                // Clustered host map pins
                let reuseidentifier = "cluster"
                if let dequeueView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseidentifier) as? MKPinAnnotationView {
                    annotationView = dequeueView
                } else {
                    annotationView =
                        MKPinAnnotationView(annotation: clusterAnnotation, reuseIdentifier: reuseidentifier)
                }
                
                // Purple pins for clusters
                annotationView?.pinTintColor = UIColor.purpleColor()
                
            } else {
                
                // Single host map pins
                let reuseidentifier = "single"
                if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseidentifier) as? MKPinAnnotationView {
                    annotationView = dequeuedView
                } else {
                    annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseidentifier)
                }
                
                // Red pins for single hosts
                annotationView?.pinTintColor = UIColor.redColor()
            }
            
            // Common cluster/non-cluster annotation configurations
            let button = UIButton(type: UIButtonType.DetailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
            annotationView?.canShowCallout = true;
        }
        
        return annotationView;
    }
    
    //    // Moves the map to users location
    //    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
    //        let userLocation = (locationManager.location?.coordinate)!
    //        mapView.setCenterCoordinate(userLocation , animated: true)
    //    }
    
    // Called when a pin is selected
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("tapped")
        //        if let clusterAnnotation = view.annotation as? CCHMapClusterAnnotation {
        //            print("cluster tapped")
        ////            let cluster = view.annotation as! KPAnnotation
        ////
        ////             zooms to location
        ////            if cluster.annotations.count > 1 {
        ////                let region = MKCoordinateRegionMakeWithDistance(cluster.coordinate,
        ////                    cluster.radius * 2.5,
        ////                    cluster.radius * 2.5)
        ////
        ////                mapView.setRegion(region, animated: true)
        ////            }
        //        } else {
        //            print("single tapped")
        //        }
    }
    
    // Called when the details button on an annotation is pressed
    //
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let clusterAnnotation = view.annotation as? CCHMapClusterAnnotation {
            if clusterAnnotation.isCluster() {
                print(clusterAnnotation.annotations)
                performSegueWithIdentifier(ToHostListSegueID, sender: clusterAnnotation)
            } else {
                if let user = clusterAnnotation.annotations.first as? WSUserLocation {
                    print(user)
                    performSegueWithIdentifier(MapToUserAccountSegueID, sender: user)
                }
            }
        }
        print("Coordinates: \(view.annotation?.coordinate)")
    }
    
    // Called when the map view changes
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // Update the annotation on the map
//        mapController.updateAnnotationsInView()
    }
}
