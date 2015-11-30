//
//  HostMapViewController+CL.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 30/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import Foundation

extension HostMapViewController : KPClusteringControllerDelegate {
    
    // MARK: KPClusteringControllerDelegate
    
    func clusteringControllerShouldClusterAnnotations(clusteringController: KPClusteringController!) -> Bool {
        return true
    }

}