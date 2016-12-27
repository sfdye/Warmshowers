//
//  DelegatesManager.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/12/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

/**
 Objects conforming to the DelegateManager protocol hold a reference to the
 common delegate objects.
 */
protocol DelegateManager {
    
    /** The session delegate holds information about the state of the current session. */
    var session: SessionDelegate { get set }
    
    /** The navigation delegate is used to sending app tracking information. */
    var navigation: NavigationDelegate { get set }
    
    /** The alert delegate manages presentation of alerts. */
    var alert: AlertDelegate { get }

}
