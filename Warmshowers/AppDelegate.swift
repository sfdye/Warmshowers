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

// View controller identifiers
let WSLoginViewControllerID = "Login"

// Error types
enum DataError : ErrorType {
    case InvalidInput
    case FailedConversion
}

// Error domain
let WSErrorDomain = "com.rajanfernandez.Warmshowers.ErrorDomain"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // app variables
    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let defaults = NSUserDefaults.standardUserDefaults()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        configureGlobalViewSettings()

        if !isLoggedin() {
            showLoginScreen()
        } else {
            showMainApp()
        }
        
        return true
    }
    
    func configureGlobalViewSettings() {
        
        // Navigation bars
        UINavigationBar.appearance().tintColor = WSColor.Blue
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: WSColor.Green,
            NSFontAttributeName: WSFont.SueEllenFrancisco(26)]
        UINavigationBar.appearance().setTitleVerticalPositionAdjustment(6, forBarMetrics: .Default)
        UINavigationBar.appearance().translucent = false
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        WSReachabilityManager.stopNotifications()
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
        WSReachabilityManager.startNotifications()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        WSReachabilityManager.stopNotifications()
    }
    
    // MARK: - Utility functions
    
    // Checks if the user is logged in
    func isLoggedin() -> Bool {
        do {
            let _ = try WSLoginData.getSessionCookie()
            return true
        } catch {
            return false
        }
    }
    
    // Shows the login page instead of the main app
    func showLoginScreen() {
        let loginViewController = storyboard.instantiateViewControllerWithIdentifier(WSLoginViewControllerID)
        self.window?.rootViewController = loginViewController
    }
    
    // Shows the main app with the tab bar
    //
    func showMainApp() {
        self.window?.rootViewController = storyboard.instantiateInitialViewController()
    }
    
    // Tasks to do when loggin out the user
    //
    func logout() {
        
        // Clear out the users messages
        do {
            try WSStore.clearout()
        } catch {
            // Suggest that the user delete the app for privacy
            let alert = UIAlertController(title: "Data Error", message: "Sorry, an error occured while removing your messages from this iPhone during the logout process. If you would like to remove your Warmshowers messages from this iPhone please try deleting the Warmshowers app.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(okAction)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            })
        }
        
        // Clear the appropriate defaults.
        do {
            try WSLoginData.removeDataForLogout()
        } catch {
            // Login data will be overwritten on next login.
        }
        
        // Go to the login screen
        showLoginScreen()
    }
    
}

