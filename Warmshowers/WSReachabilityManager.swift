//
//  WSReachabilityManager.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSReachabilityManager : WSReachabilityProtocol {
    
    static let sharedReachabilityManager = WSReachabilityManager()
    
    var reachability: Reachability? = Reachability()
    var isOnline: Bool { return reachability?.isReachable ?? false }
    
    init() {
        if reachability == nil {
            fatalError("Reachability failed to initialise")
        }
    }
    
    func startReachabilityNotifications() {
        do {
            try reachability?.startNotifier()
        } catch {
            // Failed to start reachability notifications
        }
    }
    
    func stopReachabilityNotifications() {
        reachability?.stopNotifier()
    }
    
    func registerForNotifications(_ observer: AnyObject, selector aSelector: Selector) {
        NotificationCenter.default.addObserver(observer,
            selector: aSelector,
            name: ReachabilityChangedNotification,
            object: reachability)
    }
    
    func deregisterFromNotifications(_ observer: AnyObject) {
        NotificationCenter.default.removeObserver(observer,
            name: ReachabilityChangedNotification,
            object: reachability)
    }
    
    
    // MARK: Convenience notification methods
    
    func registerForAndStartNotifications(_ observer: AnyObject, selector aSelector: Selector) {
        registerForNotifications(observer, selector: aSelector)
        startReachabilityNotifications()
    }
    
    func deregisterAndStopNotifications(_ observer: AnyObject) {
        stopReachabilityNotifications()
        deregisterFromNotifications(observer)
    }
    
}
