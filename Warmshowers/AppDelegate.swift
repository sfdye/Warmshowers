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

// TODOs
// link address in account view to open in maps/google maps options
// fix views for ipad
// add distance from loaction user
// account view actions: add action to go to messages if there are messages from the user
// show account view modally when a author name is tapped in the message view
// background message check and app icon bagde/ notifications
// add google translate feature to account view, translate from 'detect language' to system language
// search filters, i.e. by country
// - load gps files on map - start with american adventure routes on WS
// - facebook integration for finding friends on map
// - add offline country option: downloads users in one country for offline use for a few days.

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var navigation: WSNavigationDelegate = WSNavigationDelegate.sharedNavigationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
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
        UINavigationBar.appearance().setTitleVerticalPositionAdjustment(6, for: .default)
        UINavigationBar.appearance().isTranslucent = false
        
        // Toolbars
        UIToolbar.appearance().tintColor = WSColor.Blue
        
        // Search bars
        UISearchBar.appearance().tintColor = WSColor.Blue
        UISearchBar.appearance().barTintColor = WSColor.NavbarGrey
        
        // Activity indicator
        UIActivityIndicatorView.appearance().tintColor = WSColor.DarkBlue
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        WSReachabilityManager.sharedReachabilityManager.stopReachabilityNotifications()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        WSReachabilityManager.sharedReachabilityManager.startReachabilityNotifications()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        WSReachabilityManager.sharedReachabilityManager.stopReachabilityNotifications()
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        navigation.handleShortcutItem(shortcutItem, withCompletionHandler: completionHandler)
    }
}

