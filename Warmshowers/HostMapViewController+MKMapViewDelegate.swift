//
//  HostMapViewController+CLLocationManagerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

extension HostMapViewController: MKMapViewDelegate {
    
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

        
}