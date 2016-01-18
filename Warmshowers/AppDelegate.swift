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
// !!! link up system settings to the app settings !!!
// finish settings vc
// put user password in keychain

// add link to help in settings

// LATER TODOs
// login screen layout and error messages
// background message check and app icon bagde/ notifications
// mark new message threads + tab bar icon badge
// add message sorter
// add google translate feature to account view, translate from 'detect language' to system language

// IDEAS
// - load gps files on map - start with american adventure routes on WS
// - facebook integration for finding friends on map
// - add offline country option: downloads users in one country for offline use for a few days.

// View controller identifiers
let LOGIN_VC_ID = "Login"
let TABBAR_VC_ID = "TabBar"

// Defaults keys
let DEFAULTS_KEY_USERNAME = "ws_username"
let DEFAULTS_KEY_PASSWORD = "ws_password"
let DEFAULTS_KEY_SESSION_COOKIE = "ws_session_cookie"
let DEFAULTS_KEY_UID = "ws_uid"

// Error types
enum DataError : ErrorType {
    case InvalidInput
    case FailedConversion
}

enum CoreDataError : ErrorType {
    case FailedFetchReqeust
    case NotInStore
}

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
        if defaults.objectForKey(DEFAULTS_KEY_SESSION_COOKIE) != nil {
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
    
    func logout() {
        
        // Clear the appropriate defaults
        defaults.setObject(nil, forKey: DEFAULTS_KEY_PASSWORD)
        defaults.setObject(nil, forKey: DEFAULTS_KEY_UID)
        defaults.setObject(nil, forKey: DEFAULTS_KEY_SESSION_COOKIE)
        
        // Clear the database
        // TODO: clear the coredata persistant store
        
        // Go to the login screen
        showLoginScreen()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.example.test" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Warmshowers", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

