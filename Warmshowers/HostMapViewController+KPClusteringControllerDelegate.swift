//
//  HostMapViewController+CL.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation
import kingpin

extension HostMapViewController : KPClusteringControllerDelegate {
    
    // MARK: KPClusteringControllerDelegate
    
    func clusteringControllerShouldClusterAnnotations(clusteringController: KPClusteringController!) -> Bool {
        return true
    }
    
    func clusteringController(clusteringController: KPClusteringController!, configureAnnotationForDisplay annotation: KPAnnotation!) {
        if annotation.isCluster() {
            annotation.title = String(format: "%i Hosts", arguments: [annotation.annotations.count])
            annotation.subtitle = String(format: "within %0.f km", arguments: [annotation.radius/1000])
        } else {
            if let host = annotation.annotations.first as? WSUserLocation {
                annotation.title = host.title
                annotation.subtitle = host.subtitle
            }
        }
    }
    
//    -(void)clusteringController:(KPClusteringController *)clusteringController configureAnnotationForDisplay:(KPAnnotation *)annotation {
//    if ([annotation isCluster]) {
//    annotation.title = [NSString stringWithFormat:@"%lu hosts", (unsigned long)annotation.annotations.count];
//    annotation.subtitle = [NSString stringWithFormat:@"within %.0f meters", annotation.radius];
//    } else {
//    Host *host = [[annotation annotations] anyObject];
//    [annotation setTitle:[host title]];
//    [annotation setSubtitle:[host subtitle]];
//    }
//    }

}