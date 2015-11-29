//
//  AppDelegate.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 17/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import MapKit

// TODOs
// !!! link up system settings to the app settings !!!
// - fix logout problem: when http error, the apps still needs to show the login page

// IDEAS
// - load gps files on map - start with american adventure routes on WS
// - facebook integration for finding friends on map
// - add offline country option: downloads users in one country for offline use for a few days.


// keys
let LOGIN_VC_ID = "Login"
let TABBAR_VC_ID = "TabBar"
let SESSION_COOKIE = "ws_session_cookie"

// global variables
let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
let defaults = NSUserDefaults.standardUserDefaults()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        if !isLoggedin() {
            showLoginScreen()
        } else {
            showMainApp()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Utility functions
    
    // Checks if the user is logged in
    func isLoggedin() -> Bool {
        if defaults.objectForKey(SESSION_COOKIE) != nil {
            return true
        }
        return false
    }
    
    // Shows the login page instead of the main app
    func showLoginScreen() {
        let loginViewController = storyboard.instantiateViewControllerWithIdentifier(LOGIN_VC_ID)
        self.window?.rootViewController = loginViewController
    }
    
    // Shows the main app with the tab bar
    func showMainApp() {
        self.window?.rootViewController = storyboard.instantiateInitialViewController()
    }

}

