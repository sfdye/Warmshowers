//
//  WSReachabilityDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 7/05/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

protocol WSReachabilityProtocol {
    var isOnline: Bool { get }
    
    func registerForNotifications(observer: AnyObject, selector aSelector: Selector)
    
    func deregisterFromNotifications(observer: AnyObject)
    
    func registerForAndStartNotifications(observer: AnyObject, selector aSelector: Selector)
    
    func deregisterAndStopNotifications(observer: AnyObject)
}