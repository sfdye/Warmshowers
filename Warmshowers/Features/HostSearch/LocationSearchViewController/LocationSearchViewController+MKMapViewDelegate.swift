//
//  LocationSearchViewController+MKMapViewDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 1/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import CCHMapClusterController

extension LocationSearchViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if mapOverlay != nil {
            return MKTileOverlayRenderer.init(overlay: overlay)
        }
        
        // Tile coloring overlay.
        if overlay.isKind(of: MKPolygon.self) {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.fillColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: dimLevel)
            return renderer
        }
        
        // Defautlt overlay renderer.
        return MKTileOverlayRenderer.init();
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        func pinAnnotationViewForAnnotation(_ annotation: MKAnnotation, forReuseIdentifier reuseIdentifier: String) -> MKPinAnnotationView? {
            if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView {
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
                annotationView?.pinTintColor = UIColor.purple
            } else {
                // Single host map pins.
                annotationView = pinAnnotationViewForAnnotation(annotation, forReuseIdentifier: "single")
                annotationView?.pinTintColor = UIColor.red
            }
            
            // Common cluster/non-cluster annotation configurations.
            let button = UIButton(type: UIButtonType.detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
            annotationView?.canShowCallout = true
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Callout titles are set by the CCHMapClusterControllerDelegate
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let clusterAnnotation = view.annotation as? CCHMapClusterAnnotation {
            if clusterAnnotation.isCluster() {
                if let hosts = Array(clusterAnnotation.annotations) as? [WSUserLocation] {
                    navigationDelegate?.showHostListWithHosts(hosts)
                }
            } else {
                if let user = clusterAnnotation.annotations.first as? UserLocation {
                    navigationDelegate?.showUserProfileForHostWithUID(user.uid)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // Get the tiles that can be seen in the new screen.
        guard let tiles = tilesInMapRegion(mapView.region) else { return }
        
        // Abort updating if the user is zoomed out too far.
        guard zoomLevel >= minimumUpdateZoomLevel else {
            updateStatus()
            return
        }
        
        unloadAnnotationsOutOfRegion(mapView.region)

        // Update the annotations for the tiles in the view.
        for tile in tiles {
            loadAnnotationsForMapTile(tile)  
        }
        
        // Update the status label
        updateStatus()
    }
    
}
