//
//  WSMapController+CCHMapClusterController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 17/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CCHMapClusterController

extension WSMapController : CCHMapClusterControllerDelegate {
    
    // Callout titles
    func mapClusterController(mapClusterController: CCHMapClusterController!, titleForMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) -> String! {
        if mapClusterAnnotation.isCluster() {
            return "\(mapClusterAnnotation.annotations.count) hosts"
        } else {
            return (mapClusterAnnotation.annotations.first as? WSUserLocation)?.fullname ?? ""
        }
    }
    
    // Callout subtiles
    func mapClusterController(mapClusterController: CCHMapClusterController!, subtitleForMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) -> String! {
        if mapClusterAnnotation.isCluster() {
            return ""
        } else {
            return (mapClusterAnnotation.annotations.first as? WSUserLocation)?.shortAddress ?? ""
        }
    }
    
    func mapClusterController(mapClusterController: CCHMapClusterController!, willReuseMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) {
        return
    }
    
}