//
//  Delegator.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/12/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

/**
 The Delegator protocol ensures that objects which need to delegate tasks have a
 reference to the collection of app delegate objects.
 
 NOTES:
 - Object conforming to Delegator should generally only read references to
 delegate objects.
 - Setters are provided only for the convenience of testing, but should not
 normally be used.
 - It is important to keep in mind, especially during testing, that the default
 implementation of the delegates property is the DelegateManager singleton.
 Hence any delegates that are set will affect all objects conforming to the
 Delegator protocol.
 */
protocol Delegator {
    
    /**
     A reference to the delegate manager, which holds references to all the delegates.
     */
    var delegates: DelegateManager { get }
    
}

extension Delegator {
    
    public var delegates: DelegateManager {
        get {
            return Delegates.shared
        }
    }
    
    var session: SessionDelegate {
        get {
            return delegates.session
        }
        set(new) {
            Delegates.shared.session = new
        }
    }
    
    var navigation: NavigationDelegate {
        get {
            return delegates.navigation
        }
        set(new) {
            Delegates.shared.navigation = new
        }
    }
    
    var alert: AlertDelegate {
        get {
            return delegates.alert
        }
        set(new) {
            Delegates.shared.alert = new
        }
    }
    
}
