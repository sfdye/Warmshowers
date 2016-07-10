//
//  WSLocationSearchViewController+MKMapViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CCHMapClusterController

extension WSLocationSearchViewController : MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        if mapOverlay != nil {
            return MKTileOverlayRenderer.init(overlay: overlay)
        }
        
        // Tile coloring overlay.
        if overlay.isKindOfClass(MKPolygon) {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.fillColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: dimLevel)
            return renderer
        }
        
        // Defautlt overlay renderer.
        return MKTileOverlayRenderer.init();
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        func pinAnnotationViewForAnnotation(annotation: MKAnnotation, forReuseIdentifier reuseIdentifier: String) -> MKPinAnnotationView? {
            if let dequeueView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MKPinAnnotationView {
                return dequeueView
            } else {
                return MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            }
        }
        
        if annotation is MKUserLocation {
            // Return nil so map view draws "blue dot" for standard user location.
            return nil
        }
        
        var annotationView : MKPinAnnotationView?
        if let clusterAnnotation = annotation as? CCHMapClusterAnnotation {
            
            if clusterAnnotation.isCluster() {
                // Clustered host map pins.
                annotationView = pinAnnotationViewForAnnotation(annotation, forReuseIdentifier: "cluster")
                annotationView?.pinTintColor = UIColor.purpleColor()
            } else {
                // Single host map pins.
                annotationView = pinAnnotationViewForAnnotation(annotation, forReuseIdentifier: "single")
                annotationView?.pinTintColor = UIColor.redColor()
            }
            
            // Common cluster/non-cluster annotation configurations.
            let button = UIButton(type: UIButtonType.DetailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
            annotationView?.canShowCallout = true
        }
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let userLocation = (locationManager.location?.coordinate)!
        mapView.setCenterCoordinate(userLocation , animated: true)
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        // Callout titles are set by the CCHMapClusterControllerDelegate
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let clusterAnnotation = view.annotation as? CCHMapClusterAnnotation {
            if clusterAnnotation.isCluster() {
                if let hosts = Array(clusterAnnotation.annotations) as? [WSUserLocation] {
                    navigationDelegate?.showHostListWithHosts(hosts)
                }
            } else {
                if let user = clusterAnnotation.annotations.first as? WSUserLocation {
                    navigationDelegate?.showUserProfileForHostWithUID(user.uid)
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // Get the tiles that can be seen in the new screen.
        guard let tiles = tilesInView else {
            return
        }
        
        // Abort updating if there are too many tiles on the screen.
        guard tiles.count < maximumTilesInViewForUpdate else {
            statusLabel.text = textForStatusLabel()
            return
        }
        
        // Clear out annotations that are not on the tiles shown in the view.
        clearAnnotationsNotOnMapTiles(tiles)

        // Update the annotation for the tiles in the view.
        for tile in tiles {
            loadAnnotationsForMapTile(tile)
        }
        
        // Update the status label
        statusLabel.text = textForStatusLabel()
    }
}
