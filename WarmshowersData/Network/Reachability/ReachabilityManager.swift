//
//  ReachabilityManager.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

public class ReachabilityManager: ReachabilityDelegate {
    
    var reachability: Reachability? = Reachability()
    
    public var isOnline: Bool { return reachability?.isReachable ?? false }
    
    public init() {
        if reachability == nil {
            fatalError("Failed to initialise Reachability.")
        }
    }
    
    public func startReachabilityNotifications() {
        do {
            try reachability?.startNotifier()
        } catch {
            assertionFailure("Failed to start reachability notifications")
        }
    }
    
    public func stopReachabilityNotifications() {
        reachability?.stopNotifier()
    }
    
    public func registerForNotifications(_ observer: Any, selector aSelector: Selector) {
        NotificationCenter.default.addObserver(observer,
            selector: aSelector,
            name: ReachabilityChangedNotification,
            object: reachability)
    }
    
    public func deregisterFromNotifications(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer,
            name: ReachabilityChangedNotification,
            object: reachability)
    }
    
    
    // MARK: Convenience notification methods
    
    public func registerForAndStartNotifications(_ observer: Any, selector aSelector: Selector) {
        registerForNotifications(observer, selector: aSelector)
        startReachabilityNotifications()
    }
    
    public func deregisterAndStopNotifications(_ observer: Any) {
        stopReachabilityNotifications()
        deregisterFromNotifications(observer)
    }
    
}
