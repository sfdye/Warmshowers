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
    
    func registerForNotifications(_ observer: AnyObject, selector aSelector: Selector)
    
    func deregisterFromNotifications(_ observer: AnyObject)
    
    func registerForAndStartNotifications(_ observer: AnyObject, selector aSelector: Selector)
    
    func deregisterAndStopNotifications(_ observer: AnyObject)
    
}
