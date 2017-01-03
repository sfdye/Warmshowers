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
        api.contact(endPoint: .user, withMethod: .get, andPathParameters: uid, andData: nil, thenNotify: self)
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionAlert.addAction(cancelAction)
        
        if uid == user.uid {
            
            // Options for the logged in user.
            
            let logoutAction = UIAlertAction(title: "Logout", style: .default) { (logoutAction) -> Void in
                // Logout and return the login screeen.
                self.api.contact(endPoint: .logout, withMethod: .post, andPathParameters: nil, andData: nil, thenNotify: self)
                ProgressHUD.show(self.navigationController!.view, label: "Logging out ...")
            }
            actionAlert.addAction(logoutAction)
            
        } else {
            
            // Options while viewing other host profiles.
            
            let messageAction = UIAlertAction(title: "Send Message", style: .default) { (messageAction) -> Void in
                // Present compose message view
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: SID_ToSendNewMessage, sender: nil)
                })
            }
            actionAlert.addAction(messageAction)
            let provideFeedbackAction = UIAlertAction(title: "Provide Feedback", style: .default) { (messageAction) -> Void in
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
    
    func memberForTextForUser(_ user: User) -> String? {
        guard let membershipDuration = user.membershipDuration else { return "Duration of membership unknown." }
        return "Member for \(membershipDuration.asString)"
    }
    
    func activeAgoTextForUser(_ user: User) -> String? {
        guard let lastLoggedInAgo = user.lastLoggedInAgo else { return "Last login time unknown." }
        return "Active \(lastLoggedInAgo.asString) ago"
    }
    
    func languagesSpokenTextForUser(_ user: User) -> String? {
        guard let languagesspoken = user.languagesspoken else { return "Languages spoken: - " }
        return "Languages spoken: \(languagesspoken)"
    }
    
    func feedbackCellTextForUser(_ user: User) -> String {
        guard let feedback = user.feedback else { return "Feedback" }
        return feedback.count > 0 ? "Feedback (\(feedback.count))" : "No feedback"
    }
    
    func hostingInfoTitleForInfoAtIndex(_ index: Int, fromUser user: User) -> String? {
        guard index < user.hostingInfo.count else { return nil }
        let info = user.hostingInfo[index]
        switch info.type {
        case .maxCyclists:
            return "Maximum Guests:"
        case .bikeShop:
            return "Nearest bike shop:"
        case .campground:
            return "Nearest campground:"
        case .motel:
            return "Nearest hotel/motel:"
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
        return "\u{2022} " + offer.rawValue
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
            return "Home"
        case .mobile:
            return "Mobile"
        case .work:
            return "Work"
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
