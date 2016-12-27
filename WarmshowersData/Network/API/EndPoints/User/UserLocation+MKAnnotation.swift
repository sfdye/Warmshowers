//
//  UserLocation+MKAnnotation.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

extension UserLocation: MKAnnotation {
    
    @objc public var title: String? {
        return fullname
    }
    
    @objc public var subtitle: String? {
        return shortAddress
    }
    
}

