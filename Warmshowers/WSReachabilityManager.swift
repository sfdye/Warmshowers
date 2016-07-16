//
//  WSReachabilityManager.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import ReachabilitySwift

class WSReachabilityManager : WSReachabilityProtocol {
    
    static let sharedReachabilityManager = WSReachabilityManager()
    
    var reachability: Reachability
    var isOnline: Bool { return reachability.isReachable() }
    
    init() {
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            abort()
        }
    }
    
    func startReachabilityNotifications() {
        do {
            try reachability.startNotifier()
        } catch {
            // Failed to start reachability notifications
        }
    }
    
    func stopReachabilityNotifications() {
        reachability.stopNotifier()
    }
    
    func registerForNotifications(observer: AnyObject, selector aSelector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(observer,
            selector: aSelector,
            name: ReachabilityChangedNotification,
            object: reachability)
    }
    
    func deregisterFromNotifications(observer: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(observer,
            name: ReachabilityChangedNotification,
            object: reachability)
    }
    
    
    // MARK: Convenience notification methods
    
    func registerForAndStartNotifications(observer: AnyObject, selector aSelector: Selector) {
        registerForNotifications(observer, selector: aSelector)
        startReachabilityNotifications()
    }
    
    func deregisterAndStopNotifications(observer: AnyObject) {
        stopReachabilityNotifications()
        deregisterFromNotifications(observer)
    }
    
}
