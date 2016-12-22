//
//  WSAccountTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 24/11/15.
//  Copyright © 2015 Rajan Fernandez. All rights reserved.
//

import UIKit
import CoreData

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


enum HostProfileTab {
    case about
    case hosting
    case contact
}

class WSAccountTableViewController: UITableViewController {
    
    var user: WSUser?
    var recipient: WSMOUser?
    
    @IBOutlet var imageHeight: NSLayoutConstraint!
    
    // Delegates
    var navigation: WSNavigationProtocol = WSNavigationDelegate.sharedNavigationDelegate
    let session: WSSessionStateProtocol = WSSessionState.sharedSessionState
    var api: WSAPICommunicatorProtocol = WSAPICommunicator.sharedAPICommunicator
    var connection: WSReachabilityProtocol = WSReachabilityManager.sharedReachabilityManager
    var store: WSStoreProtocol = WSStore.sharedStore
    var alert: WSAlertProtocol = WSAlertDelegate.sharedAlertDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(user != nil, "Account view loaded with nil user info.")
        guard user != nil else {
            let alert = UIAlertController(title: "Sorry, an error occured.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (okAction) -> Void in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Configure the view
        navigationItem.title = ""
        navigationItem.leftBarButtonItem?.tintColor = WarmShowersColor.LightGrey
        tableView.rowHeight = UITableViewAutomaticDimension
        configureDoneButton()
        
        // Get the users profile image if they have one.
        if user?.profileImage == nil && user?.profileImageURL != nil {
            api.contact(endPoint: .ImageResource, withPathParameters: user?.profileImageURL, andData: nil, thenNotify: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Download the users feedback.
        api.contact(endPoint: .UserFeedback, withPathParameters: String(user!.uid) as NSString, andData: nil, thenNotify: self)
    }

    
    /** Sets up a done button if one is needed. */
    func configureDoneButton() {
        if navigationController?.viewControllers.count < 2 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(WSAccountTableViewController.doneButtonPressed))
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
                self.api.contact(endPoint: .Logout, withPathParameters: nil, andData: nil, thenNotify: self)
                WSProgressHUD.show(self.navigationController!.view, label: "Logging out ...")
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
    
    func memberForTextForUser(_ user: WSUser) -> String? {
        guard let membershipDuration = user.membershipDuration else { return "Duration of membership unknown." }
        return "Member for \(membershipDuration.asString)"
    }
    
    func activeAgoTextForUser(_ user: WSUser) -> String? {
        guard let lastLoggedInAgo = user.lastLoggedInAgo else { return "Last login time unknown." }
        return "Active \(lastLoggedInAgo.asString) ago"
    }
    
    func languagesSpokenTextForUser(_ user: WSUser) -> String? {
        guard let languagesspoken = user.languagesspoken else { return "Languages spoken: - " }
        return "Languages spoken: \(languagesspoken)"
    }
    
    func feedbackCellTextForUser(_ user: WSUser) -> String {
        guard let feedback = user.feedback else { return "Feedback" }
        return feedback.count > 0 ? "Feedback (\(feedback.count))" : "No feedback"
    }
    
    func hostingInfoTitleForInfoAtIndex(_ index: Int, fromUser user: WSUser) -> String? {
        guard index < user.hostingInfo.count else { return nil }
        let info = user.hostingInfo[index]
        switch info.type {
        case .maxCyclists:
            return "Maximum Guests:"
        case .bikeShop:
            return "Distance to nearest bike shop:"
        case .campground:
            return "Distance to nearest campground:"
        case .motel:
            return "Distance to nearest hotel/motel:"
        }
    }
    
    func hostingInfoDetailForInfoAtIndex(_ index: Int, fromUser user: WSUser) -> String? {
        guard index < user.hostingInfo.count else { return nil }
        let info = user.hostingInfo[index]
        return info.description
    }
    
    func offerTextForOfferAtIndex(_ index: Int, fromUser user: WSUser) -> String? {
        guard index < user.offers.count else { return nil }
        let offer = user.offers[index]
        return "\u{2022} " + offer.rawValue
    }
    
    func phoneNumberForPhoneNumberAtIndex(_ index: Int, fromUser user: WSUser) -> String? {
        guard index < user.phoneNumbers.count else { return nil }
        let phoneNumber = user.phoneNumbers[index]
        return phoneNumber.number
    }
    
    func phoneNumberDescriptionForPhoneNumberAtIndex(_ index: Int, fromUser user: WSUser) -> String? {
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
    
    func phoneNumberTypeForPhoneAtIndex(_ index: Int, fromUser user: WSUser) -> WSPhoneNumberType? {
        guard index < user.phoneNumbers.count else { return nil }
        let phoneNumber = user.phoneNumbers[index]
        return phoneNumber.type
    }
    
    func addressTextForUser(_ user: WSUser) -> String? {
        return user.address
    }

}
