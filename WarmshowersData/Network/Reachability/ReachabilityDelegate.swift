//
//  ReachabilityDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 7/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

public protocol ReachabilityDelegate {
    
    var isOnline: Bool { get }
    
    func startReachabilityNotifications()
    
    func stopReachabilityNotifications()
    
    func registerForNotifications(_ observer: Any, selector aSelector: Selector)
    
    func deregisterFromNotifications(_ observer: Any)
    
    func registerForAndStartNotifications(_ observer: Any, selector aSelector: Selector)
    
    func deregisterAndStopNotifications(_ observer: Any)
    
}
