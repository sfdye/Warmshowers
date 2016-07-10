//
//  AppDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 17/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit
import CoreData

// FIRST TODOs
// fix map loading errors: manage map pins with core data to avoid memory warnings.
// fix views for ipad

// LATER TODOs
// convert user info request to subclass of wsrequestwithcsrftoken
// add distance from loaction to account view
// account view actions: add action to go to messages if there are messages from the user
// show account view modally when a author name is tapped in the message view
// map search debouncing
// background message check and app icon bagde/ notifications
// add message sorter
// add google translate feature to account view, translate from 'detect language' to system language
// search filters, i.e. by country
// - load gps files on map - start with american adventure routes on WS
// - facebook integration for finding friends on map
// - add offline country option: downloads users in one country for offline use for a few days.
// link address in account view to open in maps/google maps options

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        configureGlobalViewSettings()
        
        if !WSSessionState.sharedSessionState.isLoggedIn {
            WSNavigationDelegate.sharedNavigationDelegate.showLoginScreen()
        } else {
            WSNavigationDelegate.sharedNavigationDelegate.showMainApp()
        }
        
        return true
    }
    
    func configureGlobalViewSettings() {
        
        // Tabbar
        UITabBar.appearance().tintColor = WSColor.Blue
        
        // Navigation bars
        UINavigationBar.appearance().tintColor = WSColor.Blue
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: WSColor.Green,
            NSFontAttributeName: WSFont.SueEllenFrancisco(26)]
        UINavigationBar.appearance().setTitleVerticalPositionAdjustment(6, forBarMetrics: .Default)
        UINavigationBar.appearance().translucent = false
        
        // Toolbars
        UIToolbar.appearance().tintColor = WSColor.Blue
        
        // Search bars
        UISearchBar.appearance().tintColor = WSColor.Blue
        UISearchBar.appearance().barTintColor = WSColor.NavbarGrey
        
        // Activity indicator
        UIActivityIndicatorView.appearance().tintColor = WSColor.DarkBlue
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        WSReachabilityManager.sharedReachabilityManager.stopReachabilityNotifications()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        WSReachabilityManager.sharedReachabilityManager.startReachabilityNotifications()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        WSReachabilityManager.sharedReachabilityManager.stopReachabilityNotifications()
    }
}

