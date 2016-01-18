//
//  HostSearchViewController+CL.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation
import kingpin

extension HostSearchViewController : KPClusteringControllerDelegate {
    
    // MARK: KPClusteringControllerDelegate
    
    func clusteringControllerShouldClusterAnnotations(clusteringController: KPClusteringController!) -> Bool {
        return true
    }
    
    func clusteringController(clusteringController: KPClusteringController!, configureAnnotationForDisplay annotation: KPAnnotation!) {
        if annotation.isCluster() {
            annotation.title = String(format: "%i Hosts", arguments: [annotation.annotations.count])
            let radius = WSDistance(metres: annotation.radius)
            annotation.subtitle = String(format: "within %@", arguments: [radius.stringWithUnits(WSSettings.metric())])            
        } else {
            if let host = annotation.annotations.first as? WSUserLocation {
                annotation.title = host.title
                annotation.subtitle = host.subtitle
            }
        }
    }

}