//
//  WSUserLocation+MKAnnotation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

extension WSUserLocation : MKAnnotation {
    
    var title: String? {
        return fullname
    }
    
    var subtitle: String? {
        return shortAddress
    }

}

