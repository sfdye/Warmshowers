//
//  WSUserLocation+MKAnnotation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

extension WSUserLocation : MKAnnotation {
    
    var title: String? {
        return fullname
    }
    
    var subtitle: String? {
        
        var subtitle: String? = ""
        
        if distance != nil {
            subtitle! += String(format: "within %.0f kilometres", arguments: [distance!])
        }
        
        return subtitle
    }

}

