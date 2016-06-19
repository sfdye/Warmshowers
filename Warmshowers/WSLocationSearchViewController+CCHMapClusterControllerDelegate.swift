//
//  WSLocationSearchViewController+CCHMapClusterControllerDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/06/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CCHMapClusterController

extension WSLocationSearchViewController: CCHMapClusterControllerDelegate {
    
    func mapClusterController(mapClusterController: CCHMapClusterController!, titleForMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) -> String! {
        let numberOfHosts = mapClusterAnnotation.annotations.count
        if numberOfHosts > 1 {
            return "\(numberOfHosts) Hosts"
        } else {
            return (mapClusterAnnotation.annotations.first as? WSUserLocation)?.title ?? ""
        }
    }
    
}