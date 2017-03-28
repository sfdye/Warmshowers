//
//  UserProfileTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 24/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import WarmshowersData

enum HostProfileTab {
    case about
    case hosting
    case contact
}

class UserProfileTableViewController: UITableViewController, Delegator, DataSource {
    
    var uid: Int?
    
    var user: User?
    
    @IBOutlet var imageHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        navigationItem.title = ""
        navigationItem.leftBarButtonItem?.tintColor = WarmShowersColor.LightGrey
        tableView.rowHeight = UITableViewAutomaticDimension
        configureDoneButton()
        
        // Download the users profile.
        api.contact(endPoint: .user, withMethod: .get, andPathParameters: uid, andData: nil, thenNotify: self, ignoreCache: false)
    }
    
    /** Sets up a done button if one is needed. */
    func configureDoneButton() {
        if navigationController!.viewControllers.count < 2 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UserProfileTableViewController.doneButtonPressed))
        }
    }
    
    /** Configures the popover menu for when the action button is pressed. */
    func actionAlertForUserWithUID(_ uid: Int) -> UIAlertController? {
        
        guard let user = user, let uid = session.uid else { return nil }
        
        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Common actions
        let button = NSLocalizedString("Cancel", comment: "Cancel button title")
        let cancelAction = UIAlertAction(title: button, style: .cancel, handler: nil)
        actionAlert.addAction(cancelAction)
        
        if uid == user.uid {
            
            // Options for the logged in user.
            
            let logoutOptionTitle = NSLocalizedString("Logout", comment: "User profile menu option title")
            let logoutAction = UIAlertAction(title: logoutOptionTitle, style: .default) { (logoutAction) -> Void in
                // Logout and return the login screeen.
                self.api.contact(endPoint: .logout, withMethod: .post, andPathParameters: nil, andData: nil, thenNotify: self, ignoreCache: false)
                let logoutMessage = NSLocalizedString("Logging out ...", comment: "Message shown with the spinner during the logout process.")
                ProgressHUD.show(self.navigationController!.view, label: logoutMessage)
            }
            actionAlert.addAction(logoutAction)
            
        } else {
            
            // Options while viewing other host profiles.
            
            let sendMessageOptionTitle = NSLocalizedString("Send Message", comment: "User profile menu option title")
            let messageAction = UIAlertAction(title: sendMessageOptionTitle, style: .default) { (messageAction) -> Void in
                // Present compose message view
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: SID_ToSendNewMessage, sender: nil)
                })
            }
            actionAlert.addAction(messageAction)
            
            let provideFeedbackOptionTitle = NSLocalizedString("Provide Feedback", comment: "User profile menu option title")
            let provideFeedbackAction = UIAlertAction(title: provideFeedbackOptionTitle, style: .default) { (messageAction) -> Void in
                // Present provide feeback view
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: SID_ToProvideFeeedback, sender: nil)
                })
            }
            actionAlert.addAction(provideFeedbackAction)
        }
        
        return actionAlert
    }

    // MARK: Utilities
    
    /** Reloads the view. */
    func reload() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    // Formats an integer time (in seconds) to a String with the two largest time units
    // i.e. 4 months 6 days
    //      2 hours 3 minutes
    func timeIntervalAsString(_ timeInterval: Int) -> String {
        
        /*
        public struct WSTimeInterval {
            
         
            
            var time: Int
            
            init(timeInterval: TimeInterval) {
                time = Int(timeInterval)
            }
            
            init(timeInterval: Int) {
                time = timeInterval
            }
            
        }
         
 */
        
        var time = timeInterval
        let maxUnitsInString = 2
        var count = 0
        var string = ""
        let units: [TimeUnit] = [.years, .months, .weeks, .days, .hours, .minutes, .seconds]
        
        func done() -> Bool {
            return (count >= maxUnitsInString) ? true : false
        }
        
        func integerTime(_ unit: TimeUnit) -> Int {
            return time / unit.inSeconds
        }
        
        func addToString(_ value: Int, unit: TimeUnit) {
            if !done() {
                let plural = (value != 1) ? true : false
                if count > 0 {
                    string += " "
                }
                string += stringValue(forQuantity: value, ofTimeUnit: unit)
                count += 1
                return
            } else {
                return
            }
        }
        
        func addToTime(_ value: Int, unit: TimeUnit) {
            time += value * unit.inSeconds
        }
        
        func stringValue(forQuantity quantity: Int, ofTimeUnit timeUnit: TimeUnit) -> String {
            switch timeUnit {
            case .seconds:
                return String(format: NSLocalizedString("%d seconds", comment: "Time format specified in stringsdict"), quantity)
            case .minutes:
                return String(format: NSLocalizedString("%d minutes", comment: "Time format specified in stringsdict"), quantity)
            case .hours:
                return String(format: NSLocalizedString("%d hours", comment: "Time format specified in stringsdict"), quantity)
            case .days:
                return String(format: NSLocalizedString("%d days", comment: "Time format specified in stringsdict"), quantity)
            case .weeks:
                return String(format: NSLocalizedString("%d weeks", comment: "Time format specified in stringsdict"), quantity)
            case .months:
                return String(format: NSLocalizedString("%d months", comment: "Time format specified in stringsdict"), quantity)
            case .years:
                return String(format: NSLocalizedString("%d years", comment: "Time format specified in stringsdict"), quantity)
            }
        }
        
        // Loop though the time units and add the two largest non-zero quantities of time to the string
        for unit in units {
            if !done() {
                let t = integerTime(unit)
                if t > 0 {
                    addToString(t, unit: unit)
                    addToTime(-t, unit: unit)
                }
                
            } else {
                continue
            }
        }
        return string
    }
    
    func memberForTextForUser(_ user: User) -> String? {
        guard let membershipDuration = user.membershipDuration else {
            return NSLocalizedString("Duration of membership unknown.", comment: "Unkown membership duration label on user profile")
        }
        let time = timeIntervalAsString(membershipDuration)
        return String(format: NSLocalizedString("Member for %@", comment: "Membership duration format. The specifier is filled with a time value with up to two time units, i.e. 4 months and 3 weeks"), time)
    }
    
    func activeAgoTextForUser(_ user: User) -> String? {
        guard let lastLoggedInAgo = user.lastLoggedInAgo else {
            return NSLocalizedString("Last login time unknown.", comment: "Unknown last login time label on user profile")
        }
        let time = timeIntervalAsString(lastLoggedInAgo)
        return String(format: NSLocalizedString("Active %@ ago", comment: "Time interval since the user was last logged in. The specifier is filled with a time value with up to two time units, i.e. 4 months and 3 weeks"), time)
    }
    
    func languagesSpokenTextForUser(_ user: User) -> String? {
        var value = "-"
        if let languagesspoken = user.languagesspoken { value = languagesspoken }
        return NSLocalizedString("Languages spoken", comment: "Languages spoken label on user profile") + ": \(value)"
    }
    
    func feedbackCellTextForUser(_ user: User) -> String {
        let feedbackLabel = NSLocalizedString("Feedback", comment: "Feedback link text")
        guard let feedback = user.feedback else { return feedbackLabel }
        return feedback.count > 0 ? feedbackLabel + "(\(feedback.count))" : NSLocalizedString("No feedback", comment: "Feedback link placholder text")
    }
    
    func hostingInfoTitleForInfoAtIndex(_ index: Int, fromUser user: User) -> String? {
        guard index < user.hostingInfo.count else { return nil }
        let info = user.hostingInfo[index]
        switch info.type {
        case .maxCyclists:
            return NSLocalizedString("Maximum Guests", comment: "Hosting info label") + ":"
        case .bikeShop:
            return NSLocalizedString("Nearest bike shop", comment: "Hosting info label") + ":"
        case .campground:
            return NSLocalizedString("Nearest campground", comment: "Hosting info label") + ":"
        case .motel:
            return NSLocalizedString("Nearest hotel/motel", comment: "Hosting info label") + ":"
        }
    }
    
    func hostingInfoDetailForInfoAtIndex(_ index: Int, fromUser user: User) -> String? {
        guard index < user.hostingInfo.count else { return nil }
        let info = user.hostingInfo[index]
        return info.description
    }
    
    func offerTextForOfferAtIndex(_ index: Int, fromUser user: User) -> String? {
        guard index < user.offers.count else { return nil }
        let offer = user.offers[index]
        var offerLabel: String = ""
        switch offer {
        case .Bed:
            offerLabel = NSLocalizedString("Bed", comment: "Host offering catagory")
        case .Food:
            offerLabel = NSLocalizedString("Food", comment: "Host offering catagory")
        case .Laundry:
            offerLabel = NSLocalizedString("Laundry", comment: "Host offering catagory")
        case .LawnSpace:
            offerLabel = NSLocalizedString("Lawn Space (for camping)", comment: "Host offering catagory")
        case .SAG:
            offerLabel = NSLocalizedString("SAG (vehicle support)", comment: "Host offering catagory")
        case .Shower:
            offerLabel = NSLocalizedString("Shower", comment: "Host offering catagory")
        case .Storage:
            offerLabel = NSLocalizedString("Storage", comment: "Host offering catagory")
        case .KitchenUse:
            offerLabel = NSLocalizedString("Use of Kitchen", comment: "Host offering catagory")
        }
        return "\u{2022} " + offerLabel
    }
    
    func phoneNumberForPhoneNumberAtIndex(_ index: Int, fromUser user: User) -> String? {
        guard index < user.phoneNumbers.count else { return nil }
        let phoneNumber = user.phoneNumbers[index]
        return phoneNumber.number
    }
    
    func phoneNumberDescriptionForPhoneNumberAtIndex(_ index: Int, fromUser user: User) -> String? {
        guard index < user.phoneNumbers.count else { return nil }
        let phoneNumber = user.phoneNumbers[index]
        switch phoneNumber.type {
        case .home:
            return NSLocalizedString("Home", comment: "Home phone label")
        case .mobile:
            return NSLocalizedString("Mobile", comment: "Mobile phone label")
        case .work:
            return NSLocalizedString("Work", comment: "Work phone label")
        }
    }
    
    func phoneNumberTypeForPhoneAtIndex(_ index: Int, fromUser user: User) -> PhoneNumberType? {
        guard index < user.phoneNumbers.count else { return nil }
        let phoneNumber = user.phoneNumbers[index]
        return phoneNumber.type
    }
    
    func addressTextForUser(_ user: User) -> String? {
        return user.address
    }

}
