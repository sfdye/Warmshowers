//
//  Delegates.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 27/12/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

/**
 This singleton class holds a reference to all the standard delegates that are
 used by view controllers throughout the app (e.g. the session delegate, navigation
 delegate, etc).
 Note that this object does nothing but provide routing to the current instance
 of delegate obejcts. Therefore, testing is not required.
 */
public class Delegates: DelegateManager {
    
    public static var shared = Delegates()
    
    // MARK - Delegate manager
    
    var session: SessionDelegate = Session.shared
    var navigation: NavigationDelegate = Navigation.shared
    var alert: AlertDelegate = Alert.shared
    
}
