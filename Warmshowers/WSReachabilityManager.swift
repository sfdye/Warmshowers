//
//  WSReachabilityManager.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 19/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit
import ReachabilitySwift

class WSReachabilityManager {
    
    private static let reachability: Reachability? = {
        let reachability: Reachability?
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            return reachability
        } catch {
            print("Unable to create Reachability")
            return nil
        }
    }()
    
    static var sharedInstance: Reachability? = WSReachabilityManager.reachability
    
    static func startNotifications() {
        do {
            try WSReachabilityManager.sharedInstance?.startNotifier()
        } catch {
            print("Failed to start reachability notifications")
        }
    }
    
    static func stopNotifications() {
        WSReachabilityManager.sharedInstance?.stopNotifier()
    }
    
    static func registerForNotifications(observer: AnyObject, selector aSelector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(observer,
            selector: aSelector,
            name: ReachabilityChangedNotification,
            object: WSReachabilityManager.sharedInstance)
    }
    
    static func deregisterFromNotifications(observer: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(observer,
            name: ReachabilityChangedNotification,
            object: WSReachabilityManager.sharedInstance)
    }
    
    
    // MARK: Convenience notification methods
    
    static func registerForAndStartNotifications(observer: AnyObject, selector aSelector: Selector) {
        WSReachabilityManager.registerForNotifications(observer, selector: aSelector)
        WSReachabilityManager.startNotifications()
    }
    
    static func deregisterAndStopNotifications(observer: AnyObject) {
        WSReachabilityManager.stopNotifications()
        WSReachabilityManager.deregisterFromNotifications(observer)
    }
    
}
