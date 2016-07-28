//
//  WSAccountTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 24/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

enum HostProfileTab {
    case About
    case Hosting
    case Contact
}

class WSAccountTableViewController: UITableViewController {
    
    var user: WSUser?
    var recipient: CDWSUser?
    
    @IBOutlet var imageHeight: NSLayoutConstraint!
    
    // Delegates
    var navigation: WSNavigationProtocol = WSNavigationDelegate.sharedNavigationDelegate
    let session: WSSessionStateProtocol = WSSessionState.sharedSessionState
    var api: WSAPICommunicatorProtocol = WSAPICommunicator.sharedAPICommunicator
    var connection: WSReachabilityProtocol = WSReachabilityManager.sharedReachabilityManager
    var store: WSStoreProtocol = WSStore.sharedStore
    var participantStore: WSStoreParticipantProtocol = WSStore.sharedStore
    var alert: WSAlertProtocol = WSAlertDelegate.sharedAlertDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(user != nil, "Account view loaded with nil user info.")
        guard user != nil else {
            let alert = UIAlertController(title: "Sorry, an error occured.", message: nil, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (okAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        // Configure the view
        navigationItem.title = ""
        navigationItem.leftBarButtonItem?.tintColor = WSColor.LightGrey
        tableView.rowHeight = UITableViewAutomaticDimension
        configureDoneButton()
        
        // Get the users profile image if they have one.
        if user?.profileImage == nil && user?.profileImageURL != nil {
            api.contactEndPoint(.ImageResource, withPathParameters: user?.profileImageURL, andData: nil, thenNotify: self)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // Download the users feedback.
        api.contactEndPoint(.UserFeedback, withPathParameters: String(user!.uid) as NSString, andData: nil, thenNotify: self)
    }

    
    /** Sets up a done button if one is needed. */
    func configureDoneButton() {
        if navigationController?.viewControllers.count < 2 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(WSAccountTableViewController.doneButtonPressed))
        }
    }
    
    /** Configures the popover menu for when the action button is pressed. */
    func actionAlertForUserWithUID(uid: Int) -> UIAlertController? {
        
        guard let user = user, let uid = session.uid else { return nil }
        
        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        // Common actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        actionAlert.addAction(cancelAction)
        
        if uid == user.uid {
            
            // Options for the logged in user.
            
            let logoutAction = UIAlertAction(title: "Logout", style: .Default) { (logoutAction) -> Void in
                // Logout and return the login screeen.
                self.api.contactEndPoint(.Logout, withPathParameters: nil, andData: nil, thenNotify: self)
                WSProgressHUD.show(self.navigationController!.view, label: "Logging out ...")
            }
            actionAlert.addAction(logoutAction)
            
        } else {
            
            // Options while viewing other host profiles.
            
            let messageAction = UIAlertAction(title: "Send Message", style: .Default) { (messageAction) -> Void in
                // Present compose message view
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier(SID_ToSendNewMessage, sender: nil)
                })
            }
            actionAlert.addAction(messageAction)
            let provideFeedbackAction = UIAlertAction(title: "Provide Feedback", style: .Default) { (messageAction) -> Void in
                // Present provide feeback view
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier(SID_ToProvideFeeedback, sender: nil)
                })
            }
            actionAlert.addAction(provideFeedbackAction)
        }
        
        return actionAlert
    }

    // MARK: Utilities
    
    /** Reloads the view. */
    func reload() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    func memberForTextForUser(user: WSUser) -> String? {
        guard let membershipDuration = user.membershipDuration else { return "Duration of membership unknown." }
        return "Member for \(membershipDuration.asString)"
    }
    
    func activeAgoTextForUser(user: WSUser) -> String? {
        guard let lastLoggedInAgo = user.lastLoggedInAgo else { return "Last login time unknown." }
        return "Active \(lastLoggedInAgo.asString) ago"
    }
    
    func languagesSpokenTextForUser(user: WSUser) -> String? {
        guard let languagesspoken = user.languagesspoken else { return "Languages spoken: - " }
        return "Languages spoken: \(languagesspoken)"
    }
    
    func feedbackCellTextForUser(user: WSUser) -> String {
        guard let feedback = user.feedback else { return "Feedback" }
        return feedback.count > 0 ? "Feedback (\(feedback.count))" : "No feedback"
    }
    
    func hostingInfoTitleForInfoAtIndex(index: Int, fromUser user: WSUser) -> String? {
        guard index < user.hostingInfo.count else { return nil }
        let info = user.hostingInfo[index]
        switch info.type {
        case .MaxCyclists:
            return "Maximum Guests:"
        case .BikeShop:
            return "Distance to nearest bike shop:"
        case .Campground:
            return "Distance to nearest campground:"
        case .Motel:
            return "Distance to nearest hotel/motel:"
        }
    }
    
    func hostingInfoDetailForInfoAtIndex(index: Int, fromUser user: WSUser) -> String? {
        guard index < user.hostingInfo.count else { return nil }
        let info = user.hostingInfo[index]
        return info.description
    }
    
    func offerTextForOfferAtIndex(index: Int, fromUser user: WSUser) -> String? {
        guard index < user.offers.count else { return nil }
        let offer = user.offers[index]
        return "\u{2022} " + offer.rawValue
    }
    
    func phoneNumberForPhoneNumberAtIndex(index: Int, fromUser user: WSUser) -> String? {
        guard index < user.phoneNumbers.count else { return nil }
        let phoneNumber = user.phoneNumbers[index]
        return phoneNumber.number
    }
    
    func phoneNumberDescriptionForPhoneNumberAtIndex(index: Int, fromUser user: WSUser) -> String? {
        guard index < user.phoneNumbers.count else { return nil }
        let phoneNumber = user.phoneNumbers[index]
        switch phoneNumber.type {
        case .Home:
            return "Home"
        case .Mobile:
            return "Mobile"
        case .Work:
            return "Work"
        }
    }
    
    func phoneNumberTypeForPhoneAtIndex(index: Int, fromUser user: WSUser) -> WSPhoneNumberType? {
        guard index < user.phoneNumbers.count else { return nil }
        let phoneNumber = user.phoneNumbers[index]
        return phoneNumber.type
    }
    
    func addressTextForUser(user: WSUser) -> String? {
        return user.address
    }
    
    func logout() {
        do {
            session.deleteSessionData()
            try store.clearout()
            navigation.showLoginScreen()
        } catch {
            // Suggest that the user delete the app for privacy.
            alert.presentAlertFor(self, withTitle: "Data Error", button: "OK", message: "Sorry, an error occured while removing your account data from this iPhone. If you would like to remove your Warmshowers messages from this iPhone please try deleting the Warmshowers app.", andHandler: { [weak self] (action) in
                self?.navigation.showLoginScreen()
                })
        }
    }

}
