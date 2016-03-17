//
//  WSMapManager+CCHMapClusterController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 17/03/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation
import CCHMapClusterController

extension WSMapManager : CCHMapClusterControllerDelegate {
    
    func mapClusterController(mapClusterController: CCHMapClusterController!, subtitleForMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) -> String! {
        return ""
    }
    
    func mapClusterController(mapClusterController: CCHMapClusterController!, titleForMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) -> String! {
        return nil
    }
    
    func mapClusterController(mapClusterController: CCHMapClusterController!, willReuseMapClusterAnnotation mapClusterAnnotation: CCHMapClusterAnnotation!) {
        return
    }
    
}